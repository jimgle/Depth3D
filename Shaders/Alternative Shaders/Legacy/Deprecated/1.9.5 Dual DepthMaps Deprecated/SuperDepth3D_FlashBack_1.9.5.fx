 ////--------------------------//
 ///**SuperDepth3D_FlashBack**///
 //--------------------------////

 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 //* Depth Map Based 3D post-process shader v1.9.5																																	*//
 //* For Reshade 3.0																																								*//
 //* --------------------------																																						*//
 //* This work is licensed under a Creative Commons Attribution 3.0 Unported License.																								*//
 //* So you are free to share, modify and adapt it for your needs, and even use it for commercial use.																				*//
 //* I would also love to hear about a project you are using it with.																												*//
 //* https://creativecommons.org/licenses/by/3.0/us/																																*//
 //*																																												*//
 //* Have fun,																																										*//
 //* Jose Negrete AKA BlueSkyDefender																																				*//
 //*																																												*//
 //* http://reshade.me/forum/shader-presentation/2128-sidebyside-3d-depth-map-based-stereoscopic-shader																				*//	
 //* ---------------------------------																																				*//
 //*																																												*//
 //* Original work was based on Shader Based on forum user 04348 and be located here http://reshade.me/forum/shader-presentation/1594-3d-anaglyph-red-cyan-shader-wip#15236			*//
 //*																																												*//
 //* 																																												*//
 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
 // Determines The size of the Depth Map. For 4k Use 2 or 2.5. For 1440p Use 1.5 or 2. For 1080p use 1.

#define Depth_Map_Division 1.5

uniform bool MIX <
	ui_label = "Mix Selection";
	ui_tooltip = "Select how you like mix the Depth Maps.";
> = 0;

uniform float Adjust <
	ui_type = "drag";
	ui_min = 0; ui_max = 1;
	ui_label = "Mix Adjust";
	ui_tooltip = "Adjust How you mix both Depth Maps. Default is 0.50 = 50% mix.";
> = 0.50;
uniform int Alternate_Depth_Map_One <
	ui_type = "combo";
	ui_items = "DM 0\0DM 1\0DM 2\0DM 3\0DM 4\0DM 5\0DM 6\0DM 7\0DM 8\0DM 9\0DM 10\0DM 11\0DM 12\0DM 13\0DM 14\0DM 15\0DM 16\0DM 17\0DM 18\0DM 19\0DM 20\0DM 21\0DM 22\0DM 23\0DM 24\0DM 25\0DM 26\0DM 27\0DM 28\0DM 29\0DM 30\0DM 31\0DM 32\0DM 33\0DM 34\0DM 35\0DM 36\0DM 37\0DM 38\0DM 39\0DM 40\0";
	ui_label = "Depth Map One";
	ui_tooltip = "Alternate Depth Map for different Games. Read the ReadMeDepth3d.txt, for setting. Each game May and can use a diffrent Alternet Depth Map.";
> = 0;

uniform int Alternate_Depth_Map_Two <
	ui_type = "combo";
	ui_items = "DM 0\0DM 1\0DM 2\0DM 3\0DM 4\0DM 5\0DM 6\0DM 7\0DM 8\0DM 9\0DM 10\0DM 11\0DM 12\0DM 13\0DM 14\0DM 15\0DM 16\0DM 17\0DM 18\0DM 19\0DM 20\0DM 21\0DM 22\0DM 23\0DM 24\0DM 25\0DM 26\0DM 27\0DM 28\0DM 29\0DM 30\0DM 31\0DM 32\0DM 33\0DM 34\0DM 35\0DM 36\0DM 37\0DM 38\0DM 39\0DM 40\0";
	ui_label = "Depth Map Two";
	ui_tooltip = "Alternate Depth Map for different Games. Read the ReadMeDepth3d.txt, for setting. Each game May and can use a diffrent Alternet Depth Map.";
> = 0;

uniform int Depth <
	ui_type = "drag";
	ui_min = 0; ui_max = 30;
	ui_label = "Depth Slider";
	ui_tooltip = "Determines the amount of Image Warping and Separation between both eyes. To go beyond 25 max you need to enter your own number.";
> = 10;

uniform float Depth_Limit <
	ui_type = "drag";
	ui_min = 0.500; ui_max = 1.0;
	ui_label = "Depth Limit";
	ui_tooltip = "Limit how far Depth Image Warping is done. Default is One.";
> = 1.0;

uniform float Perspective <
	ui_type = "drag";
	ui_min = -50; ui_max = 50;
	ui_label = "Perspective Slider";
	ui_tooltip = "Determines the perspective point.";
> = 0;

uniform bool Depth_Map_View <
	ui_label = "Depth Map View";
	ui_tooltip = "Display the Depth Map. Use This to Work on your Own Depth Map for your game.";
> = false;	

uniform int Weapon_Depth_Map <
	ui_type = "combo";
	ui_items = "Weapon Depth Map Off\0Custom Weapon Depth Map One\0Custom Weapon Depth Map Two\0Custom Weapon Depth Map Three\0Custom Weapon Depth Map Four\0WDM 1\0WDM 2\0WDM 3\0WDM 4\0WDM 5\0WDM 6\0WDM 7\0WDM 8\0WDM 9\0WDM 10\0WDM 11\0WDM 12\0WDM 13\0WDM 14\0WDM 15\0WDM 16\0WDM 17\0WDM 18\0WDM 19\0WDM 20\0WDM 21\0WDM 22\0WDM 23\0";
	ui_label = "Alternate Weapon Depth Map";
	ui_tooltip = "Alternate Weapon Depth Map for different Games. Read the ReadMeDepth3d.txt, for setting.";
> = 0;

uniform float3 Weapon_Adjust <
	ui_type = "drag";
	ui_min = -1.0; ui_max = 1.500;
	ui_label = "Weapon Adjust Depth Map";
	ui_tooltip = "Adjust weapon depth map. Default is (Y 0, X 0.250, Z 1.001)";
> = float3(0.0,0.250,1.001);

uniform float Weapon_Percentage <
	ui_type = "drag";
	ui_min = -1.0; ui_max = 5.0;
	ui_label = "Weapon Percentage";
	ui_tooltip = "Adjust weapon percentage. Default is 5.0";
> = 5.0;

uniform bool Depth_Map_Flip <
	ui_label = "Depth Map Flip";
	ui_tooltip = "Depth Flip if the depth map is Upside Down.";
> = false;

uniform int Custom_Depth_Map <
	ui_type = "combo";
	ui_items = "Custom Off\0Custom One\0Custom Two\0Custom Three\0Custom Four\0Custom Five\0Custom Six\0Custom Seven\0Custom Eight\0Custom Nine\0Custom Ten\0Custom Eleven\0Custom Twelve\0";
	ui_label = "Custom Depth Map";
	ui_tooltip = "Adjust your own Custom Depth Map.";
> = 0;

uniform float2 Near_Far <
	ui_type = "drag";
	ui_min = 0; ui_max = 100;
	ui_label = "Near & Far";
	ui_tooltip = "Adjustment for Near and Far Depth Map Precision.";
> = float2(1,1.5);

uniform int Stereoscopic_Mode <
	ui_type = "combo";
	ui_items = "Side by Side\0Top and Bottom\0Line Interlaced\0Checkerboard 3D\0";
	ui_label = "3D Display Mode";
	ui_tooltip = "Side by Side/Top and Bottom/Line Interlaced/Checkerboard 3D display output.";
> = 0;

uniform int Downscaling_Support <
	ui_type = "combo";
	ui_items = "Native\0Option One\0Option Two\0";
	ui_label = "Downscaling Support";
	ui_tooltip = "Dynamic Super Resolution & Virtual Super Resolution downscaling support for Line Interlaced & Checkerboard 3D displays.";
> = 0;

uniform bool Eye_Swap <
	ui_label = "Eye Swap";
	ui_tooltip = "Left right image change.";
> = false;

/////////////////////////////////////////////D3D Starts Here/////////////////////////////////////////////////////////////////

#define pix float2(BUFFER_RCP_WIDTH, BUFFER_RCP_HEIGHT)

texture DepthBufferTex : DEPTH;

sampler DepthBuffer 
	{ 
		Texture = DepthBufferTex; 
	};

texture BackBufferTex : COLOR;

sampler BackBuffer 
	{ 
		Texture = BackBufferTex;
	};

texture texL  { Width = BUFFER_WIDTH/Depth_Map_Division; Height = BUFFER_HEIGHT/Depth_Map_Division; Format = RGBA32F;}; 
sampler SamplerL
	{
		Texture = texL;
	};
	
texture texR  { Width = BUFFER_WIDTH/Depth_Map_Division; Height = BUFFER_HEIGHT/Depth_Map_Division; Format = RGBA32F;}; 
sampler SamplerR
	{
		Texture = texR;
	};

	
	
//Depth Map Information	
float4 DepthMapOne(float2 texcoord : TEXCOORD0) : SV_Target
{

	 float4 color = 0;

			if (Depth_Map_Flip)
			texcoord.y =  1 - texcoord.y;
	
	float4 depthM = tex2D(DepthBuffer, float2(texcoord.x-(Depth/25)*pix.x,texcoord.y));
	float4 WDM = tex2D(DepthBuffer, float2(texcoord.x, texcoord.y));
		
		if (Custom_Depth_Map == 0)
	{	
		//Alien Isolation | Firewatch
		if (Alternate_Depth_Map_One == 0)
		{
		float cF = 1000000000;
		float cN = 1;	
		depthM = (exp(depthM * log(cF + cN)) - cN) / cF;
		}
		
		//Amnesia: The Dark Descent
		if (Alternate_Depth_Map_One == 1)
		{
		float cF = 1000;
		float cN = 1;
		depthM = cN/(cN-cF) / ( depthM - cF/(cF-cN));
		}
		
		//Among The Sleep | Soma
		if (Alternate_Depth_Map_One == 2)
		{
		float cF = 10;
		float cN = 0.05;
		depthM = cN/(cN-cF) / ( depthM - cF/(cF-cN));
		}
		
		//The Vanishing of Ethan Carter Redux
		if (Alternate_Depth_Map_One == 3)
		{
		float cF  = 0.0075;
		float cN = 1;
		depthM =  (cN * cF / (cF + depthM * (cN - cF))); 
		}
		
		//Batman Arkham Knight | Batman Arkham Origins | Batman: Arkham City | BorderLands 2 | Hard Reset | Lords Of The Fallen | The Elder Scrolls V: Skyrim
		if (Alternate_Depth_Map_One == 4)
		{
		float cF = 50;
		float cN = 0;
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Call of Duty: Advance Warfare | Call of Duty: Black Ops 2 | Call of Duty: Ghost | Call of Duty: Infinite Warfare 
		if (Alternate_Depth_Map_One == 5)
		{
		float cF = 25;
		float cN = 1;
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Casltevania: Lord of Shadows - UE | Dead Rising 3
		if (Alternate_Depth_Map_One == 6)
		{
		float cF = 25;
		float cN = 0;
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Doom 2016
		if (Alternate_Depth_Map_One == 7)
		{
		float cF = 25;
		float cN = 5;
		depthM =  (exp(pow(depthM, depthM + cF / pow(depthM, cN) - 1 * (pow((depthM), cN)))) - 1) / (exp(depthM) - 1);
		}
		
		//Deadly Premonition:The Directors's Cut
		if (Alternate_Depth_Map_One == 8)
		{
		float cF = 30;
		float cN = 0;
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Dragon Ball Xenoverse | Quake 2 XP
		if (Alternate_Depth_Map_One == 9)
		{
		float cF = 1;
		float cN = 0.005;
		depthM = cN/(cN-cF) / ( depthM - cF/(cF-cN));
		}
		
		//Warhammer: End Times - Vermintide | Fallout 4 
		if (Alternate_Depth_Map_One == 10)
		{
		float cF = 7.0;
		float cN = 1.5;
		depthM = (exp(pow(depthM, depthM + cF / pow(depthM, cN) - 1 * (pow((depthM), cN)))) - 1) / (exp(depthM) - 1);
		}
		
		//Dying Light
		if (Alternate_Depth_Map_One == 11)
		{
		float cF = 100;
		float cN = 0.0075;
		depthM = cF / (1 + cF - (depthM/cN) * (1 - cF));
		}
		
		//GTA V
		if (Alternate_Depth_Map_One == 12)
		{
		float cF  = 10000; 
		float cN = 0.0075; 
		depthM = cF / (1 + cF - (depthM/cN) * (1 - cF));
		}
		
		//Magicka 2
		if (Alternate_Depth_Map_One == 13)
		{
		float cF = 1.025;
		float cN = 0.025;	
		depthM = clamp(pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000)/0.5,0,1.25);
		}
		
		//Middle-earth: Shadow of Mordor
		if (Alternate_Depth_Map_One == 14)
		{
		float cF = 650;
		float cN = 651;
		depthM = pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000);
		}
		
		//Naruto Shippuden UNS3 Full Blurst
		if (Alternate_Depth_Map_One == 15)
		{
		float cF = 150;
		float cN = 0.001;
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Shadow warrior(2013)XP
		if (Alternate_Depth_Map_One == 16)
		{
		float cF = 5;
		float cN = 0.05;
		depthM = cN/(cN-cF) / ( depthM - cF/(cF-cN));
		}
		
		//Ryse: Son of Rome
		if (Alternate_Depth_Map_One == 17)
		{
		float cF = 1.010;
		float cN = 0;
		depthM = pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000);
		}
		
		//Sleeping Dogs: DE
		if (Alternate_Depth_Map_One == 18)
		{
		float cF  = 1;
		float cN = 0.025;
		depthM =  (cN * cF / (cF + depthM * (cN - cF))); 
		}
		
		//Souls Games
		if (Alternate_Depth_Map_One == 19)
		{
		float cF = 1.050;
		float cN = 0.025;
		depthM = pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000);
		}
		
		//Witcher 3
		if (Alternate_Depth_Map_One == 20)
		{
		float cF = 7.5;
		float cN = 1;	
		depthM = (pow(abs(cN-depthM),cF));
		}

		//Assassin Creed Unity | Just Cause 3
		if (Alternate_Depth_Map_One == 21)
		{
		float cF = 150;
		float cN = 151;
		depthM = pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000);
		}	
		
		//Silent Hill: Homecoming
		if (Alternate_Depth_Map_One == 22)
		{
		float cF = 25;
		float cN = 25.869;
		depthM = clamp(1 - (depthM * cF / (cF - cN) + cN) / depthM,0,255);
		}
		
		//Monstrum DX11
		if (Alternate_Depth_Map_One == 23)
		{
		float cF = 1.075;	
		float cN = 0;
		depthM = pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000);
		}
		
		//S.T.A.L.K.E.R:SoC
		if (Alternate_Depth_Map_One == 24)
		{
		float cF = 1.001;
		float cN = 0;
		depthM = pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000);
		}
		
		//Double Dragon Neon
		if (Alternate_Depth_Map_One == 25)
		{
		float cF = 0.5;
		float cN = 0.150;
		depthM = log(depthM / cN) / log(cF / cN);
		}
		
		//Deus Ex: Mankind Divided
		if (Alternate_Depth_Map_One == 26)
		{
		float cF = 250;
		float cN = 251;
		depthM = pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000);
		}	
		
		//The Elder Scrolls V: Skyrim Special Edition
		if (Alternate_Depth_Map_One == 27)
		{
		float cF = 20;
		float cN = 0;
		depthM =  (exp(pow(depthM, depthM + cF / pow(depthM, cN) - 1 * (pow((depthM), cN)))) - 1) / (exp(depthM) - 1);
		}
		
		//Rage64|
		if (Alternate_Depth_Map_One == 28)
		{
		float cF = 50;
		float cN = -0.5;
		depthM =  (exp(pow(depthM, depthM + cF / pow(depthM, cN) - 1 * (pow((depthM), cN)))) - 1) / (exp(depthM) - 1);
		}
		
		//Through The Woods
		if (Alternate_Depth_Map_One == 29)
		{
		float cF = 25;
		float cN = 0;
		depthM =  (exp(pow(depthM, depthM + cF / pow(depthM, cN) - 1 * (pow((depthM), cN)))) - 1) / (exp(depthM) - 1);
		}
		
		//Amnesia: Machine for Pigs
		if (Alternate_Depth_Map_One == 30)
		{
		float cF = 100;
		float cN = 0;
		depthM =  (exp(pow(depthM, depthM + cF / pow(depthM, cN) - 1 * (pow((depthM), cN)))) - 1) / (exp(depthM) - 1);
		}
		
		//Requiem: Avenging Angel
		if (Alternate_Depth_Map_One == 31)
		{
		float cF = 100;
		float cN = 1.555;
		depthM = 1 - log(pow(abs(cN-depthM),cF));
		}
		
		//Turok: Dinosaur Hunter
		if (Alternate_Depth_Map_One == 32)
		{
		float cF = 1000; //10+
		float cN = 0;//1
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Never Alone (Kisima Ingitchuna)
		if (Alternate_Depth_Map_One == 33)
		{
		float cF = 112.5;
		float cN = 1.995;
		depthM = 1 - log(pow(abs(cN-depthM),cF));
		}
		
		//Stacking
		if (Alternate_Depth_Map_One == 34)
		{
		float cF = 15;
		float cN = 0;
		depthM =  (exp(pow(depthM, depthM + cF / pow(depthM, cN) - 1 * (pow((depthM), cN)))) - 1) / (exp(depthM) - 1);
		}
		
		//Fez
		if (Alternate_Depth_Map_One == 35)
		{
		float cF = 25.0;
		float cN = 1.5125;
		depthM = clamp(1 - log(pow(abs(cN-depthM),cF)),0,1);
		}
		
		//Lara Croft & Temple of Osiris
		if (Alternate_Depth_Map_One == 36)
		{
		float cF = 0.340;//1.010+	or 150
		float cN = 12.250;//0 or	151
		depthM = 1 - clamp(pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),10),0,1);
		}
		
		//DreamFall Chapters
		if (Alternate_Depth_Map_One == 37)
		{
		float cF = 100;	
		float cN = 5;	
		depthM = (exp(depthM * log(cF + cN)) - cN) / cF;
		}
		
		//DreamFall Chapters
		if (Alternate_Depth_Map_One == 38)
		{
		float cF = 100;	
		float cN = 100;	
		depthM = (exp(depthM * log(cF + cN)) - cN) / cF;
		}
		
		//LOZ TP HD
		if (Alternate_Depth_Map_One == 39)
		{
		float cF = 100;
		float cN = 2.250;
		depthM = (exp(depthM * log(cF + cN)) - cN) / cF;
		}
		
		//God of War Ghost of Sparta
		if (Alternate_Depth_Map_One == 40)
		{
		float cF = 10.5;
		float cN = 0.02;
		depthM = (pow(abs(cN-depthM),cF));
		}
		
	}
	else
	{
	
		//Custom One
		if (Custom_Depth_Map == 1)
		{
		float cF = Near_Far.y; //10+
		float cN = Near_Far.x;//1
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Custom Two
		if (Custom_Depth_Map == 2)
		{
		float cF  = Near_Far.y; //100+
		float cN = Near_Far.x; //0.01-
		depthM = cF / (1 + cF - (depthM/cN) * (1 - cF));
		}
		
		//Custom Three
		if (Custom_Depth_Map == 3)
		{
		float cF  = Near_Far.y;//0.025
		float cN = Near_Far.x;//1.0
		depthM =  (cN * cF / (cF + depthM * (cN - cF))); 
		}
		
		//Custom Four
		if (Custom_Depth_Map == 4)
		{
		float cF = Near_Far.y;//1000000000 or 1	
		float cN = Near_Far.x;//0 or 13	
		depthM = (exp(depthM * log(cF + cN)) - cN) / cF;
		}
		
		//Custom Five
		if (Custom_Depth_Map == 5)
		{
		float cF = Near_Far.y;//1
		float cN = Near_Far.x;//0.025
		depthM = cN/(cN-cF) / ( depthM - cF/(cF-cN));
		}
		
		//Custom Six
		if (Custom_Depth_Map == 6)
		{
		float cF = Near_Far.y;//1
		float cN = Near_Far.x;//1.875
		depthM = clamp(1 - (depthM * cF / (cF - cN) + cN) / depthM,0,255); //Infinite reversed-Z. Clamped, not so Infinate anymore.
		}
		
		//Custom Seven
		if (Custom_Depth_Map == 7)
		{
		float cF = Near_Far.y;//1.01	
		float cN = Near_Far.x;//0	
		depthM = clamp(pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000)/0.5,0,1.25);
		}
		
		//Custom Eight
		if (Custom_Depth_Map == 8)
		{
		float cF = Near_Far.y;//1.010+	or 150
		float cN = Near_Far.x;//0 or	151
		depthM = pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000);
		}
		
		//Custom Nine
		if (Custom_Depth_Map == 9)
		{
		float cF = Near_Far.y;
		float cN = Near_Far.x;
		depthM = log(depthM / cN) / log(cF / cN);
		}
		
		//Custom Ten
		if (Custom_Depth_Map == 10)
		{
		float cF = Near_Far.y;//5
		float cN = Near_Far.x;//5
		depthM =  (exp(pow(depthM, depthM + cF / pow(depthM, cN) - 1 * (pow((depthM), cN)))) - 1) / (exp(depthM) - 1);
		}
		
		//Custom Eleven
		if (Custom_Depth_Map == 11)
		{
		float cF = Near_Far.y;//1.010+	or 150
		float cN = Near_Far.x;//0 or	151
		depthM = 1 - log(pow(abs(cN-depthM),cF));
		}
		
		//Custom Twelve
		if (Custom_Depth_Map == 12)
		{
		float cF = Near_Far.y;//
		float cN = Near_Far.x;//
		depthM = 1 - clamp(pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),10),0,1);
		}
		
	}
		
	float4 D;
	float4 depthMFar;
	float4 depthMFarT;
	
	float Adj;
	float Per;
		
		//Custom Weapon Depth Profile One	
		if (Weapon_Depth_Map == 1)
		{
		Adj = Weapon_Adjust.x;//0
		Per = Weapon_Percentage;//5
		float cWF = Weapon_Adjust.y;//0.250
		float cWN = Weapon_Adjust.z;//1.001
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Custom Weapon Depth Profile Two
		if (Weapon_Depth_Map == 2)
		{
		Adj = Weapon_Adjust.x;//0
		Per = Weapon_Percentage;//5
		float cWF = Weapon_Adjust.y;//-1000
		float cWN = Weapon_Adjust.z;//0.985
		WDM = (log(cWF / cWN*WDM - cWF));
		}
		
		//Custom Weapon Depth Profile Three	
		if (Weapon_Depth_Map == 3)
		{
		Adj = Weapon_Adjust.x;//0
		Per = Weapon_Percentage;//5
		float cWF = Weapon_Adjust.y;//0.250
		float cWN = Weapon_Adjust.z;//1.001
		WDM = (log(cWF * cWN/WDM - cWF));
		}
		
		//Custom Weapon Depth Profile Four	
		if (Weapon_Depth_Map == 4)
		{
		Adj = Weapon_Adjust.x;//0
		Per = Weapon_Percentage;//5
		float cWF = Weapon_Adjust.y;//-0.05
		float cWN = Weapon_Adjust.z;//0.500
		WDM = 1 - (log(cWN * WDM)/ 1 - log(cWF+WDM));
		}
		
		//Weapon Depth Map One
		if (Weapon_Depth_Map == 5)
		{
		Adj = 0;
		Per = 5;
		float cWF = -1000;
		float cWN = 0.9856;
		WDM = (log(cWF / cWN*WDM - cWF));
		}
		
		//Weapon Depth Map Two
		if (Weapon_Depth_Map == 6)
		{
		Adj = 0.001;
		Per = 0.440;
		float cWF = 0.255;
		float cWN = 1.001;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Three
		if (Weapon_Depth_Map == 7)
		{
		Adj = 0.000;
		Per = 0.180;
		float cWF = 0.235;
		float cWN = 1.001;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Four
		if (Weapon_Depth_Map == 8)
		{
		Adj = 0.00000001;
		Per = 0.675;
		float cWF = 10;
		float cWN = 0.0085;
		WDM = (log(cWF / cWN*WDM - cWF));
		}
		
		//Weapon Depth Map Five
		if (Weapon_Depth_Map == 9)
		{
		Adj = 0.001;
		Per = 0.525;
		float cWF = 0.080;
		float cWN = 1.001;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Six
		if (Weapon_Depth_Map == 10)
		{
		Adj = 0;
		Per = 0.500;
		float cWF = -1.9;
		float cWN = 1.001;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Seven
		if (Weapon_Depth_Map == 11)
		{
		Adj = 0.125;
		Per = 1;
		float cWF = -1.0;
		float cWN = -0.1;
		WDM = (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Eight
		if (Weapon_Depth_Map == 12)
		{
		Adj = 0.037;
		Per = 5.0;
		float cWF = 0.75;
		float cWN = -1.0;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Nine
		if (Weapon_Depth_Map == 13)
		{
		Adj = 0.000001;
		Per = 5.0;
		float cWF = 0.0045;
		float cWN = 100;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Ten
		if (Weapon_Depth_Map == 14)
		{
		Adj = 0.0;
		Per = 2;
		float cWF = 37.5;
		float cWN = 0.523;
		WDM = (log(cWF / cWN*WDM - cWF));
		}
		
		//Weapon Depth Map Eleven
		if (Weapon_Depth_Map == 15)
		{
		Adj = 0.0003;
		Per = 0.625;
		float cWF = 0.625;
		float cWN = 1.001;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Twelve
		if (Weapon_Depth_Map == 16)
		{
		Adj = 0.050;
		Per = 1.0;
		float cWF = 1.5;
		float cWN = 1.7;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Thirteen
		if (Weapon_Depth_Map == 17)
		{
		Adj = 0;
		Per = 0.666;
		float cWF = -0.06;
		float cWN = 0.666;
		WDM = 1 - (log(cWN * WDM)/ 1 - log(cWF+WDM));
		}
		
		//Weapon Depth Map Fourteen
		if (Weapon_Depth_Map == 18)
		{
		Adj = 0;
		Per = 0.500;
		float cWF = -0.0865;
		float cWN = -0.2;
		WDM = 1 - (log(cWN * WDM)/ 1 - log(cWF+WDM));
		}
		
		//Weapon Depth Map Fifteen
		if (Weapon_Depth_Map == 19)
		{
		Adj = 0.000001;
		Per = 5;
		float cWF = 1.6;
		float cWN = 1.001;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Profile Sixteen
		if (Weapon_Depth_Map == 20)
		{
		Adj = 0.00000001;
		Per = 5;
		float cWF = -0.4925;
		float cWN = 0.200;
		WDM = 1 - (log(cWN * WDM)/ 1 - log(cWF+WDM));
		}
		
		//Weapon Depth Profile Seventeen
		if (Weapon_Depth_Map == 21)
		{
		Adj = 0.040;
		Per = 5;
		float cWF = 0.051;
		float cWN = 1.250;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Profile Eighteen
		if (Weapon_Depth_Map == 22)
		{
		Adj = 0;
		Per = 0.580;
		float cWF = -0.005;
		float cWN = 1.5;
		WDM = 1 - (log(cWN * WDM)/ 1 - log(cWF+WDM));
		}
		
		//Weapon Depth Profile Nineteen
		if (Weapon_Depth_Map == 23)
		{
		Adj = 0.0001;
		Per = 5;
		float cWF = 0.025;
		float cWN = 1.001;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Profile Twenty
		if (Weapon_Depth_Map == 24)
		{
		Adj = 0.0001;
		Per = 5;
		float cWF = 0.035;
		float cWN = 1.001;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Profile Twenty One
		if (Weapon_Depth_Map == 25)
		{
		Adj = 0.000010;
		Per = 5;
		float cWF = -0.4;
		float cWN = 0.375;
		WDM = 1 - (log(cWN * WDM)/ 1 - log(cWF+WDM));
		}
		
		//Weapon Depth Profile Twenty Two
		if (Weapon_Depth_Map == 26)
		{
		Adj = 0.102000;
		Per = 3.650000;
		float cWF = 0.001300;
		float cWN = 50.000000;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Twenty Three
		if (Weapon_Depth_Map == 27)
		{
		Adj = 0.00000001;
		Per = 0.6;//0.675
		float cWF = 4.925;//10
		float cWN = 0.0075;//0.0085
		WDM = (log(cWF / cWN*WDM - cWF));
		}
		
	float NearDepth;
	
	if (Weapon_Depth_Map == 27 || Weapon_Depth_Map == 23 || Weapon_Depth_Map == 20 || Weapon_Depth_Map == 19 || Weapon_Depth_Map == 13 || Weapon_Depth_Map == 8)
	{
	NearDepth = step(depthM.r,Adj/100000);
	}
	else
	{
	NearDepth = step(depthM.r,Adj);
	}

		if (Weapon_Depth_Map <= 0)
		{
		D = depthM;
		}
		else
		{
		D = lerp(depthM,WDM%Per,NearDepth);
		}

    
	color.rgb = min(Depth_Limit,D.rrr);
	
	return color;	

}

float4 DepthMapTwo(float2 texcoord : TEXCOORD0) : SV_Target
{

	 float4 color = 0;

			if (Depth_Map_Flip)
			texcoord.y =  1 - texcoord.y;
	
	float4 depthM = tex2D(DepthBuffer, float2(texcoord.x+(Depth/25)*pix.x,texcoord.y));
	float4 WDM = tex2D(DepthBuffer, float2(texcoord.x, texcoord.y));
		
		if (Custom_Depth_Map == 0)
	{	
		//Alien Isolation | Firewatch
		if (Alternate_Depth_Map_Two == 0)
		{
		float cF = 1000000000;
		float cN = 1;	
		depthM = (exp(depthM * log(cF + cN)) - cN) / cF;
		}
		
		//Amnesia: The Dark Descent
		if (Alternate_Depth_Map_Two == 1)
		{
		float cF = 1000;
		float cN = 1;
		depthM = cN/(cN-cF) / ( depthM - cF/(cF-cN));
		}
		
		//Among The Sleep | Soma
		if (Alternate_Depth_Map_Two == 2)
		{
		float cF = 10;
		float cN = 0.05;
		depthM = cN/(cN-cF) / ( depthM - cF/(cF-cN));
		}
		
		//The Vanishing of Ethan Carter Redux
		if (Alternate_Depth_Map_Two == 3)
		{
		float cF  = 0.0075;
		float cN = 1;
		depthM =  (cN * cF / (cF + depthM * (cN - cF))); 
		}
		
		//Batman Arkham Knight | Batman Arkham Origins | Batman: Arkham City | BorderLands 2 | Hard Reset | Lords Of The Fallen | The Elder Scrolls V: Skyrim
		if (Alternate_Depth_Map_Two == 4)
		{
		float cF = 50;
		float cN = 0;
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Call of Duty: Advance Warfare | Call of Duty: Black Ops 2 | Call of Duty: Ghost | Call of Duty: Infinite Warfare 
		if (Alternate_Depth_Map_Two == 5)
		{
		float cF = 25;
		float cN = 1;
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Casltevania: Lord of Shadows - UE | Dead Rising 3
		if (Alternate_Depth_Map_Two == 6)
		{
		float cF = 25;
		float cN = 0;
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Doom 2016
		if (Alternate_Depth_Map_Two == 7)
		{
		float cF = 25;
		float cN = 5;
		depthM =  (exp(pow(depthM, depthM + cF / pow(depthM, cN) - 1 * (pow((depthM), cN)))) - 1) / (exp(depthM) - 1);
		}
		
		//Deadly Premonition:The Directors's Cut
		if (Alternate_Depth_Map_Two == 8)
		{
		float cF = 30;
		float cN = 0;
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Dragon Ball Xenoverse | Quake 2 XP
		if (Alternate_Depth_Map_Two == 9)
		{
		float cF = 1;
		float cN = 0.005;
		depthM = cN/(cN-cF) / ( depthM - cF/(cF-cN));
		}
		
		//Warhammer: End Times - Vermintide | Fallout 4 
		if (Alternate_Depth_Map_Two == 10)
		{
		float cF = 7.0;
		float cN = 1.5;
		depthM = (exp(pow(depthM, depthM + cF / pow(depthM, cN) - 1 * (pow((depthM), cN)))) - 1) / (exp(depthM) - 1);
		}
		
		//Dying Light
		if (Alternate_Depth_Map_Two == 11)
		{
		float cF = 100;
		float cN = 0.0075;
		depthM = cF / (1 + cF - (depthM/cN) * (1 - cF));
		}
		
		//GTA V
		if (Alternate_Depth_Map_Two == 12)
		{
		float cF  = 10000; 
		float cN = 0.0075; 
		depthM = cF / (1 + cF - (depthM/cN) * (1 - cF));
		}
		
		//Magicka 2
		if (Alternate_Depth_Map_Two == 13)
		{
		float cF = 1.025;
		float cN = 0.025;	
		depthM = clamp(pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000)/0.5,0,1.25);
		}
		
		//Middle-earth: Shadow of Mordor
		if (Alternate_Depth_Map_Two == 14)
		{
		float cF = 650;
		float cN = 651;
		depthM = pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000);
		}
		
		//Naruto Shippuden UNS3 Full Blurst
		if (Alternate_Depth_Map_Two == 15)
		{
		float cF = 150;
		float cN = 0.001;
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Shadow warrior(2013)XP
		if (Alternate_Depth_Map_Two == 16)
		{
		float cF = 5;
		float cN = 0.05;
		depthM = cN/(cN-cF) / ( depthM - cF/(cF-cN));
		}
		
		//Ryse: Son of Rome
		if (Alternate_Depth_Map_Two == 17)
		{
		float cF = 1.010;
		float cN = 0;
		depthM = pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000);
		}
		
		//Sleeping Dogs: DE
		if (Alternate_Depth_Map_Two == 18)
		{
		float cF  = 1;
		float cN = 0.025;
		depthM =  (cN * cF / (cF + depthM * (cN - cF))); 
		}
		
		//Souls Games
		if (Alternate_Depth_Map_Two == 19)
		{
		float cF = 1.050;
		float cN = 0.025;
		depthM = pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000);
		}
		
		//Witcher 3
		if (Alternate_Depth_Map_Two == 20)
		{
		float cF = 7.5;
		float cN = 1;	
		depthM = (pow(abs(cN-depthM),cF));
		}

		//Assassin Creed Unity | Just Cause 3
		if (Alternate_Depth_Map_Two == 21)
		{
		float cF = 150;
		float cN = 151;
		depthM = pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000);
		}	
		
		//Silent Hill: Homecoming
		if (Alternate_Depth_Map_Two == 22)
		{
		float cF = 25;
		float cN = 25.869;
		depthM = clamp(1 - (depthM * cF / (cF - cN) + cN) / depthM,0,255);
		}
		
		//Monstrum DX11
		if (Alternate_Depth_Map_Two == 23)
		{
		float cF = 1.075;	
		float cN = 0;
		depthM = pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000);
		}
		
		//S.T.A.L.K.E.R:SoC
		if (Alternate_Depth_Map_Two == 24)
		{
		float cF = 1.001;
		float cN = 0;
		depthM = pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000);
		}
		
		//Double Dragon Neon
		if (Alternate_Depth_Map_Two == 25)
		{
		float cF = 0.5;
		float cN = 0.150;
		depthM = log(depthM / cN) / log(cF / cN);
		}
		
		//Deus Ex: Mankind Divided
		if (Alternate_Depth_Map_Two == 26)
		{
		float cF = 250;
		float cN = 251;
		depthM = pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000);
		}	
		
		//The Elder Scrolls V: Skyrim Special Edition
		if (Alternate_Depth_Map_Two == 27)
		{
		float cF = 20;
		float cN = 0;
		depthM =  (exp(pow(depthM, depthM + cF / pow(depthM, cN) - 1 * (pow((depthM), cN)))) - 1) / (exp(depthM) - 1);
		}
		
		//Rage64|
		if (Alternate_Depth_Map_Two == 28)
		{
		float cF = 50;
		float cN = -0.5;
		depthM =  (exp(pow(depthM, depthM + cF / pow(depthM, cN) - 1 * (pow((depthM), cN)))) - 1) / (exp(depthM) - 1);
		}
		
		//Through The Woods
		if (Alternate_Depth_Map_Two == 29)
		{
		float cF = 25;
		float cN = 0;
		depthM =  (exp(pow(depthM, depthM + cF / pow(depthM, cN) - 1 * (pow((depthM), cN)))) - 1) / (exp(depthM) - 1);
		}
		
		//Amnesia: Machine for Pigs
		if (Alternate_Depth_Map_Two == 30)
		{
		float cF = 100;
		float cN = 0;
		depthM =  (exp(pow(depthM, depthM + cF / pow(depthM, cN) - 1 * (pow((depthM), cN)))) - 1) / (exp(depthM) - 1);
		}
		
		//Requiem: Avenging Angel
		if (Alternate_Depth_Map_Two == 31)
		{
		float cF = 100;
		float cN = 1.555;
		depthM = 1 - log(pow(abs(cN-depthM),cF));
		}
		
		//Turok: Dinosaur Hunter
		if (Alternate_Depth_Map_Two == 32)
		{
		float cF = 1000; //10+
		float cN = 0;//1
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Never Alone (Kisima Ingitchuna)
		if (Alternate_Depth_Map_Two == 33)
		{
		float cF = 112.5;
		float cN = 1.995;
		depthM = 1 - log(pow(abs(cN-depthM),cF));
		}
		
		//Stacking
		if (Alternate_Depth_Map_Two == 34)
		{
		float cF = 15;
		float cN = 0;
		depthM =  (exp(pow(depthM, depthM + cF / pow(depthM, cN) - 1 * (pow((depthM), cN)))) - 1) / (exp(depthM) - 1);
		}
		
		//Fez
		if (Alternate_Depth_Map_Two == 35)
		{
		float cF = 25.0;
		float cN = 1.5125;
		depthM = clamp(1 - log(pow(abs(cN-depthM),cF)),0,1);
		}
		
		//Lara Croft & Temple of Osiris
		if (Alternate_Depth_Map_Two == 36)
		{
		float cF = 0.340;//1.010+	or 150
		float cN = 12.250;//0 or	151
		depthM = 1 - clamp(pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),10),0,1);
		}
		
		//DreamFall Chapters
		if (Alternate_Depth_Map_Two == 37)
		{
		float cF = 100;	
		float cN = 5;	
		depthM = (exp(depthM * log(cF + cN)) - cN) / cF;
		}
		
		//DreamFall Chapters
		if (Alternate_Depth_Map_Two == 38)
		{
		float cF = 100;	
		float cN = 100;	
		depthM = (exp(depthM * log(cF + cN)) - cN) / cF;
		}
		
		//LOZ TP HD
		if (Alternate_Depth_Map_Two == 39)
		{
		float cF = 100;
		float cN = 2.250;
		depthM = (exp(depthM * log(cF + cN)) - cN) / cF;
		}
		
		//God of War Ghost of Sparta
		if (Alternate_Depth_Map_Two == 40)
		{
		float cF = 10.5;
		float cN = 0.02;
		depthM = (pow(abs(cN-depthM),cF));
		}
		
	}
	else
	{
	
		//Custom One
		if (Custom_Depth_Map == 1)
		{
		float cF = Near_Far.y; //10+
		float cN = Near_Far.x;//1
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Custom Two
		if (Custom_Depth_Map == 2)
		{
		float cF  = Near_Far.y; //100+
		float cN = Near_Far.x; //0.01-
		depthM = cF / (1 + cF - (depthM/cN) * (1 - cF));
		}
		
		//Custom Three
		if (Custom_Depth_Map == 3)
		{
		float cF  = Near_Far.y;//0.025
		float cN = Near_Far.x;//1.0
		depthM =  (cN * cF / (cF + depthM * (cN - cF))); 
		}
		
		//Custom Four
		if (Custom_Depth_Map == 4)
		{
		float cF = Near_Far.y;//1000000000 or 1	
		float cN = Near_Far.x;//0 or 13	
		depthM = (exp(depthM * log(cF + cN)) - cN) / cF;
		}
		
		//Custom Five
		if (Custom_Depth_Map == 5)
		{
		float cF = Near_Far.y;//1
		float cN = Near_Far.x;//0.025
		depthM = cN/(cN-cF) / ( depthM - cF/(cF-cN));
		}
		
		//Custom Six
		if (Custom_Depth_Map == 6)
		{
		float cF = Near_Far.y;//1
		float cN = Near_Far.x;//1.875
		depthM = clamp(1 - (depthM * cF / (cF - cN) + cN) / depthM,0,255); //Infinite reversed-Z. Clamped, not so Infinate anymore.
		}
		
		//Custom Seven
		if (Custom_Depth_Map == 7)
		{
		float cF = Near_Far.y;//1.01	
		float cN = Near_Far.x;//0	
		depthM = clamp(pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000)/0.5,0,1.25);
		}
		
		//Custom Eight
		if (Custom_Depth_Map == 8)
		{
		float cF = Near_Far.y;//1.010+	or 150
		float cN = Near_Far.x;//0 or	151
		depthM = pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000);
		}
		
		//Custom Nine
		if (Custom_Depth_Map == 9)
		{
		float cF = Near_Far.y;
		float cN = Near_Far.x;
		depthM = log(depthM / cN) / log(cF / cN);
		}
		
		//Custom Ten
		if (Custom_Depth_Map == 10)
		{
		float cF = Near_Far.y;//5
		float cN = Near_Far.x;//5
		depthM =  (exp(pow(depthM, depthM + cF / pow(depthM, cN) - 1 * (pow((depthM), cN)))) - 1) / (exp(depthM) - 1);
		}
		
		//Custom Eleven
		if (Custom_Depth_Map == 11)
		{
		float cF = Near_Far.y;//1.010+	or 150
		float cN = Near_Far.x;//0 or	151
		depthM = 1 - log(pow(abs(cN-depthM),cF));
		}
		
		//Custom Twelve
		if (Custom_Depth_Map == 12)
		{
		float cF = Near_Far.y;//
		float cN = Near_Far.x;//
		depthM = 1 - clamp(pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),10),0,1);
		}
		
	}
		
	float4 D;
	float4 depthMFar;
	float4 depthMFarT;
	
	float Adj;
	float Per;
		
		//Custom Weapon Depth Profile One	
		if (Weapon_Depth_Map == 1)
		{
		Adj = Weapon_Adjust.x;//0
		Per = Weapon_Percentage;//5
		float cWF = Weapon_Adjust.y;//0.250
		float cWN = Weapon_Adjust.z;//1.001
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Custom Weapon Depth Profile Two
		if (Weapon_Depth_Map == 2)
		{
		Adj = Weapon_Adjust.x;//0
		Per = Weapon_Percentage;//5
		float cWF = Weapon_Adjust.y;//-1000
		float cWN = Weapon_Adjust.z;//0.985
		WDM = (log(cWF / cWN*WDM - cWF));
		}
		
		//Custom Weapon Depth Profile Three	
		if (Weapon_Depth_Map == 3)
		{
		Adj = Weapon_Adjust.x;//0
		Per = Weapon_Percentage;//5
		float cWF = Weapon_Adjust.y;//0.250
		float cWN = Weapon_Adjust.z;//1.001
		WDM = (log(cWF * cWN/WDM - cWF));
		}
		
		//Custom Weapon Depth Profile Four	
		if (Weapon_Depth_Map == 4)
		{
		Adj = Weapon_Adjust.x;//0
		Per = Weapon_Percentage;//5
		float cWF = Weapon_Adjust.y;//-0.05
		float cWN = Weapon_Adjust.z;//0.500
		WDM = 1 - (log(cWN * WDM)/ 1 - log(cWF+WDM));
		}
		
		//Weapon Depth Map One
		if (Weapon_Depth_Map == 5)
		{
		Adj = 0;
		Per = 5;
		float cWF = -1000;
		float cWN = 0.9856;
		WDM = (log(cWF / cWN*WDM - cWF));
		}
		
		//Weapon Depth Map Two
		if (Weapon_Depth_Map == 6)
		{
		Adj = 0.001;
		Per = 0.440;
		float cWF = 0.255;
		float cWN = 1.001;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Three
		if (Weapon_Depth_Map == 7)
		{
		Adj = 0.000;
		Per = 0.180;
		float cWF = 0.235;
		float cWN = 1.001;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Four
		if (Weapon_Depth_Map == 8)
		{
		Adj = 0.00000001;
		Per = 0.675;
		float cWF = 10;
		float cWN = 0.0085;
		WDM = (log(cWF / cWN*WDM - cWF));
		}
		
		//Weapon Depth Map Five
		if (Weapon_Depth_Map == 9)
		{
		Adj = 0.001;
		Per = 0.525;
		float cWF = 0.080;
		float cWN = 1.001;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Six
		if (Weapon_Depth_Map == 10)
		{
		Adj = 0;
		Per = 0.500;
		float cWF = -1.9;
		float cWN = 1.001;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Seven
		if (Weapon_Depth_Map == 11)
		{
		Adj = 0.125;
		Per = 1;
		float cWF = -1.0;
		float cWN = -0.1;
		WDM = (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Eight
		if (Weapon_Depth_Map == 12)
		{
		Adj = 0.037;
		Per = 5.0;
		float cWF = 0.75;
		float cWN = -1.0;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Nine
		if (Weapon_Depth_Map == 13)
		{
		Adj = 0.000001;
		Per = 5.0;
		float cWF = 0.0045;
		float cWN = 100;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Ten
		if (Weapon_Depth_Map == 14)
		{
		Adj = 0.0;
		Per = 2;
		float cWF = 37.5;
		float cWN = 0.523;
		WDM = (log(cWF / cWN*WDM - cWF));
		}
		
		//Weapon Depth Map Eleven
		if (Weapon_Depth_Map == 15)
		{
		Adj = 0.0003;
		Per = 0.625;
		float cWF = 0.625;
		float cWN = 1.001;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Twelve
		if (Weapon_Depth_Map == 16)
		{
		Adj = 0.050;
		Per = 1.0;
		float cWF = 1.5;
		float cWN = 1.7;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Thirteen
		if (Weapon_Depth_Map == 17)
		{
		Adj = 0;
		Per = 0.666;
		float cWF = -0.06;
		float cWN = 0.666;
		WDM = 1 - (log(cWN * WDM)/ 1 - log(cWF+WDM));
		}
		
		//Weapon Depth Map Fourteen
		if (Weapon_Depth_Map == 18)
		{
		Adj = 0;
		Per = 0.500;
		float cWF = -0.0865;
		float cWN = -0.2;
		WDM = 1 - (log(cWN * WDM)/ 1 - log(cWF+WDM));
		}
		
		//Weapon Depth Map Fifteen
		if (Weapon_Depth_Map == 19)
		{
		Adj = 0.000001;
		Per = 5;
		float cWF = 1.6;
		float cWN = 1.001;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Profile Sixteen
		if (Weapon_Depth_Map == 20)
		{
		Adj = 0.00000001;
		Per = 5;
		float cWF = -0.4925;
		float cWN = 0.200;
		WDM = 1 - (log(cWN * WDM)/ 1 - log(cWF+WDM));
		}
		
		//Weapon Depth Profile Seventeen
		if (Weapon_Depth_Map == 21)
		{
		Adj = 0.040;
		Per = 5;
		float cWF = 0.051;
		float cWN = 1.250;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Profile Eighteen
		if (Weapon_Depth_Map == 22)
		{
		Adj = 0;
		Per = 0.580;
		float cWF = -0.005;
		float cWN = 1.5;
		WDM = 1 - (log(cWN * WDM)/ 1 - log(cWF+WDM));
		}
		
		//Weapon Depth Profile Nineteen
		if (Weapon_Depth_Map == 23)
		{
		Adj = 0.0001;
		Per = 5;
		float cWF = 0.025;
		float cWN = 1.001;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Profile Twenty
		if (Weapon_Depth_Map == 24)
		{
		Adj = 0.0001;
		Per = 5;
		float cWF = 0.035;
		float cWN = 1.001;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Profile Twenty One
		if (Weapon_Depth_Map == 25)
		{
		Adj = 0.000010;
		Per = 5;
		float cWF = -0.4;
		float cWN = 0.375;
		WDM = 1 - (log(cWN * WDM)/ 1 - log(cWF+WDM));
		}
		
		//Weapon Depth Profile Twenty Two
		if (Weapon_Depth_Map == 26)
		{
		Adj = 0.102000;
		Per = 3.650000;
		float cWF = 0.001300;
		float cWN = 50.000000;
		WDM = 1 - (log(cWF * cWN/WDM - cWF));
		}
		
		//Weapon Depth Map Twenty Three
		if (Weapon_Depth_Map == 27)
		{
		Adj = 0.00000001;
		Per = 0.6;//0.675
		float cWF = 4.925;//10
		float cWN = 0.0075;//0.0085
		WDM = (log(cWF / cWN*WDM - cWF));
		}
		
	float NearDepth;
	
	if (Weapon_Depth_Map == 27 || Weapon_Depth_Map == 23 || Weapon_Depth_Map == 20 || Weapon_Depth_Map == 19 || Weapon_Depth_Map == 13 || Weapon_Depth_Map == 8)
	{
	NearDepth = step(depthM.r,Adj/100000);
	}
	else
	{
	NearDepth = step(depthM.r,Adj);
	}
	

		if (Weapon_Depth_Map <= 0)
		{
		D = depthM;
		}
		else
		{
		D = lerp(depthM,WDM%Per,NearDepth);
		}
    
	color.rgb = min(Depth_Limit,D.rrr);
	
	return color;	

}

	void  PS_calcLR(in float4 position : SV_Position, in float2 texcoord : TEXCOORD0, out float4 colorR : SV_Target0, out float4 colorL : SV_Target1)
	{
	
	float4 One;
	float4 Two;
	
	if (MIX == 0)
	{
	One = texcoord.x+Depth*pix.x*DepthMapOne(texcoord);
	Two = texcoord.x-Depth*pix.x*DepthMapTwo(texcoord);
	}
	else
	{
	One = texcoord.x+Depth*pix.x*lerp(DepthMapOne(texcoord),DepthMapTwo(texcoord),Adjust);
	Two = texcoord.x-Depth*pix.x*lerp(DepthMapOne(texcoord),DepthMapTwo(texcoord),Adjust);
	}
	
	colorL = One;
	colorR = Two;
	}
	

/////////////////////////////////////////L/R//////////////////////////////////////////////////////////////////////

	float4 L(float2 texcoord)
	{
	 float4 color;
	 
			//Workaround for DX9 Games
			int x = 5;	
			if (Depth == 0)		
				x = 0;
			else if (Depth == 1)	
				x = 1;
			else if (Depth == 2)
				x = 2;
			else if (Depth == 3)
				x = 3;
			else if (Depth == 4)
				x = 4;
			else if (Depth == 5)
				x = 5;
			else if (Depth == 6)
				x = 6;
			else if (Depth == 7)
				x = 7;
			else if (Depth == 8)
				x = 8;
			else if (Depth == 9)
				x = 9;
			else if (Depth == 10)
				x = 10;
			else if (Depth == 11)
				x = 11;
			else if (Depth == 12)
				x = 12;
			else if (Depth == 13)
				x = 13;
			else if (Depth == 14)
				x = 14;
			else if (Depth == 15)
				x = 15;
			else if (Depth == 16)
				x = 16;
			else if (Depth == 17)
				x = 17;
			else if (Depth == 18)
				x = 18;
			else if (Depth == 19)
				x = 19;			
			else if (Depth == 20)
				x = 20;			
			else if (Depth == 21)
				x = 21;			
			else if (Depth == 22)
				x = 22;			
			else if (Depth == 23)
				x = 23;		
			else if (Depth == 24)
				x = 24;			
			else if (Depth == 25)
				x = 25;
			else if (Depth == 26)
				x = 26;			
			else if (Depth == 27)
				x = 27;			
			else if (Depth == 28)
				x = 28;		
			else if (Depth == 29)
				x = 29;			
			else if (Depth == 30)
				x = 30;
							
			//Workaround for DX9 Games

		//Left
		color.rgb = tex2D(BackBuffer, float2(texcoord.x, texcoord.y)).rgb;
			
		[unroll]
		for (int i = 0; i <= x; i++) 
		{
			if (tex2D(SamplerL, float2(texcoord.x+i*pix.x,texcoord.y)).r <= texcoord.x) 
			{			
				color = tex2D(BackBuffer, float2(texcoord.x+i*pix.x,texcoord.y));
			}
		}
		return color;
	}
	
	float4 R(float2 texcoord)
	{
	 float4 color;
	 
			//Workaround for DX9 Games
			int x = 5;	
			if (Depth == 0)		
				x = 0;
			else if (Depth == 1)	
				x = 1;
			else if (Depth == 2)
				x = 2;
			else if (Depth == 3)
				x = 3;
			else if (Depth == 4)
				x = 4;
			else if (Depth == 5)
				x = 5;
			else if (Depth == 6)
				x = 6;
			else if (Depth == 7)
				x = 7;
			else if (Depth == 8)
				x = 8;
			else if (Depth == 9)
				x = 9;
			else if (Depth == 10)
				x = 10;
			else if (Depth == 11)
				x = 11;
			else if (Depth == 12)
				x = 12;
			else if (Depth == 13)
				x = 13;
			else if (Depth == 14)
				x = 14;
			else if (Depth == 15)
				x = 15;
			else if (Depth == 16)
				x = 16;
			else if (Depth == 17)
				x = 17;
			else if (Depth == 18)
				x = 18;
			else if (Depth == 19)
				x = 19;			
			else if (Depth == 20)
				x = 20;			
			else if (Depth == 21)
				x = 21;			
			else if (Depth == 22)
				x = 22;			
			else if (Depth == 23)
				x = 23;		
			else if (Depth == 24)
				x = 24;			
			else if (Depth == 25)
				x = 25;
			else if (Depth == 26)
				x = 26;			
			else if (Depth == 27)
				x = 27;			
			else if (Depth == 28)
				x = 28;		
			else if (Depth == 29)
				x = 29;			
			else if (Depth == 30)
				x = 30;
			
			//Workaround for DX9 Games

		//Right
		color.rgb = tex2D(BackBuffer, float2(texcoord.x, texcoord.y)).rgb;

		[unroll]
		for (int j = 0; j >= -x; --j) 
		{
			if (tex2D(SamplerR, float2(texcoord.x+j*pix.x,texcoord.y)).r >= texcoord.x) 
			{
				color = tex2D(BackBuffer, float2(texcoord.x+j*pix.x, texcoord.y));
			}
		}
		return color;
	}

	float4 Out(float4 pos : SV_Position, float2 texcoord : TEXCOORD0) : SV_Target
	{
	float4 color;
		if(!Depth_Map_View)
		{
			if(Stereoscopic_Mode == 0)
			{
				if(!Eye_Swap)
				{	
					color = texcoord.x < 0.5 ? L(float2((texcoord.x*2) + Perspective * pix.x,texcoord.y)) : R(float2((texcoord.x*2-1) - Perspective * pix.x,texcoord.y));
				}
				else
				{
					color = texcoord.x < 0.5 ? R(float2((texcoord.x*2) + Perspective * pix.x,texcoord.y)) : L(float2((texcoord.x*2-1) - Perspective * pix.x,texcoord.y));
				}
			}
			else if(Stereoscopic_Mode == 1)
			{
				if(!Eye_Swap)
				{
					color = texcoord.y < 0.5 ? L(float2(texcoord.x + Perspective * pix.x,texcoord.y*2)) : R(float2(texcoord.x - Perspective * pix.x,texcoord.y*2-1));
				}
				else
				{
					color = texcoord.y < 0.5 ? R(float2(texcoord.x + Perspective * pix.x,texcoord.y*2)) : L(float2(texcoord.x - Perspective * pix.x,texcoord.y*2-1));
				}
			}
			else if(Stereoscopic_Mode == 1)
			{
				float gridL;
				
				if(Downscaling_Support == 0)
				{
					gridL = frac(texcoord.y*(BUFFER_HEIGHT/2));
				}
				else if(Downscaling_Support == 1)
				{
					gridL = frac(texcoord.y*(1080.0/2));
				}
				else
				{
					gridL = frac(texcoord.y*(1081.0/2));
				}
				
				if(!Eye_Swap)
				{
					color = gridL > 0.5 ? L(float2(texcoord.x + Perspective * pix.x,texcoord.y)) : R(float2(texcoord.x - Perspective * pix.x,texcoord.y));
				}
				else
				{
					color = gridL > 0.5 ? R(float2(texcoord.x + Perspective * pix.x,texcoord.y)) : L(float2(texcoord.x - Perspective * pix.x,texcoord.y));
				}
			}
			else if(Stereoscopic_Mode == 2)
			{
			float gridy;
				float gridx;
				
				if(Downscaling_Support == 0)
				{
				gridy = floor(texcoord.y*(BUFFER_HEIGHT));
				gridx = floor(texcoord.x*(BUFFER_WIDTH));
				}
				else if(Downscaling_Support == 1)
				{
				gridy = floor(texcoord.y*(1080.0));
				gridx = floor(texcoord.x*(1080.0));
				}
				else
				{
				gridy = floor(texcoord.y*(1081.0));
				gridx = floor(texcoord.x*(1081.0));
				}
				
				if(!Eye_Swap)
				{
					color = (int(gridy+gridx) & 1) < 0.5 ? L(float2(texcoord.x + Perspective * pix.x,texcoord.y)) : R(float2(texcoord.x - Perspective * pix.x,texcoord.y));
				}
				else
				{
					color = (int(gridy+gridx) & 1) < 0.5 ? R(float2(texcoord.x + Perspective * pix.x,texcoord.y)) : L(float2(texcoord.x - Perspective * pix.x,texcoord.y));
				}
			}
		}
		else
		{
			if (Custom_Depth_Map == 0)
			{
				color = texcoord.x < 0.5 ? DepthMapOne(float2(texcoord.x*2 , texcoord.y)) : DepthMapTwo(float2(texcoord.x*2-1 , texcoord.y));
			}
			else
			{
				color = DepthMapOne(texcoord);
			}
		}
		return color;
	}

///////////////////////////////////////////////////////////ReShade.fxh/////////////////////////////////////////////////////////////
// Vertex shader generating a triangle covering the entire screen
void PostProcessVS(in uint id : SV_VertexID, out float4 position : SV_Position, out float2 texcoord : TEXCOORD)
{
	texcoord.x = (id == 2) ? 2.0 : 0.0;
	texcoord.y = (id == 1) ? 2.0 : 0.0;
	position = float4(texcoord * float2(2.0, -2.0) + float2(-1.0, 1.0), 0.0, 1.0);
}

//*Rendering passes*//

technique SuperDepth3D_FlashBack
	{
			pass
		{
			VertexShader = PostProcessVS;
			PixelShader = PS_calcLR;
			RenderTarget0 = texL;
			RenderTarget1 = texR;
		}
			pass
		{
			VertexShader = PostProcessVS;
			PixelShader = Out;
		}

	}
