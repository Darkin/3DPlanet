//
//  GameViewController.m
//  3DPlanet
//
//  Created by Darren Larkin on 2015-11-07.
//  Copyright (c) 2015 D2tech Software. All rights reserved.
//

#import "GameViewController.h"
#import <SceneKit/SceneKit.h>

@implementation GameViewController {
    SCNSphere *mySphere;
    SCNScene *myScene;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self planetSetup];
}

- (void)worldSetup {
    SCNView *scnView = (SCNView *)self.view;
    
    myScene = [[SCNScene alloc] init];
    
    SCNSphere *planetSphere = [SCNSphere sphereWithRadius:4.0];
    SCNNode *sphereNode = [SCNNode nodeWithGeometry:planetSphere];
    [myScene.rootNode addChildNode:sphereNode];
    
    
    SCNMaterial *corona = [SCNMaterial material];
    corona.diffuse.contents = [UIImage imageNamed:@"earth"];
    corona.specular.contents = [UIColor colorWithWhite:0.6 alpha:1.0];
    corona.shininess = 0.5;
    [planetSphere removeMaterialAtIndex:0];
    planetSphere.materials = @[corona];
    
    // create and add a light to the scene
    scnView.autoenablesDefaultLighting = YES;
    
    // create and add a camera to the scene
    scnView.allowsCameraControl = true;
    
    mySphere = planetSphere;
    
    scnView.scene = myScene;
}

- (void)planetSetup {
    SCNView *scnView = (SCNView *)self.view;
    
    myScene = [[SCNScene alloc] init];
    
    SCNSphere *planetSphere = [SCNSphere sphereWithRadius:5.0];
    SCNNode *sphereNode = [SCNNode nodeWithGeometry:planetSphere];
    [myScene.rootNode addChildNode:sphereNode];
    
    [myScene.rootNode addChildNode:[SCNNode nodeWithGeometry:[self planetSetupSphere:planetSphere named:@"earth"]]];
    
    // create and add a light to the scene
    //scnView.autoenablesDefaultLighting = YES;
    
    // create and add a light to the scene
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeAmbient;
    lightNode.light.color = [UIColor colorWithWhite:0.37 alpha:1.0];
    //lightNode.light.color = [UIColor blueColor];
    lightNode.position = SCNVector3Make(0, 50, 50);
    [myScene.rootNode addChildNode:lightNode];
    
    SCNNode *omniLightNode = [SCNNode node];
    omniLightNode.light = [SCNLight light];
    omniLightNode.light.type = SCNLightTypeOmni;
    omniLightNode.light.color = [UIColor colorWithWhite:.70 alpha:1.0];
    omniLightNode.position = SCNVector3Make(0, 40, 40);
    [myScene.rootNode addChildNode:omniLightNode];
    
    // create and add a camera to the scene
    scnView.allowsCameraControl = true;
    
    // create and add a camera to the scene
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.position = SCNVector3Make(0, 0, 20);
    [myScene.rootNode addChildNode:cameraNode];
    
    mySphere = planetSphere;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextPlanet)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    scnView.scene = myScene;
}

- (SCNGeometry*)planetSetupSphere:(SCNGeometry*)sphere named:(NSString*)planetName {
    
    SCNMaterial *corona = [SCNMaterial material];
    corona.diffuse.contents = [UIImage imageNamed:planetName];
    corona.specular.contents = [UIColor colorWithWhite:0.6 alpha:1.0];
    corona.shininess = 0.5;
    [sphere removeMaterialAtIndex:0];
    sphere.materials = @[corona];
    return sphere;
}

- (void)nextPlanet {
    static int x = 0;
    x++;
    NSString* planetName;
    switch (x) {
        case 0:
            planetName = @"earth";
            break;
        case 1:
            planetName = @"EarthSummerMed.jpg";
            break;
        case 2:
            planetName = @"FlagWorld";
            break;
        case 3:
            planetName = @"EarthBoard.jpg";
            break;
        case 4:
            planetName = @"EarthBlack.jpg";
            break;
        case 5:
            planetName = @"mars";
            break;
        case 6:
            planetName = @"Pluto";
            break;
        default:
            planetName = @"earth";
            break;
    }
    if (x>=7) {
        x=0;
    }
    [myScene.rootNode addChildNode:[SCNNode nodeWithGeometry:[self planetSetupSphere:mySphere named:planetName]]];
}


- (void)planeSetup {
    // create a new scene
    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.dae"];
    
    // create and add a camera to the scene
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    [scene.rootNode addChildNode:cameraNode];
    
    // place the camera
    cameraNode.position = SCNVector3Make(0, 0, 15);
    
    // create and add a light to the scene
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 10, 10);
    [scene.rootNode addChildNode:lightNode];
    
    // create and add an ambient light to the scene
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [scene.rootNode addChildNode:ambientLightNode];
    
    // retrieve the ship node
    SCNNode *ship = [scene.rootNode childNodeWithName:@"ship" recursively:YES];
    
    // animate the 3d object
    [ship runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    // set the scene to the view
    scnView.scene = scene;
    
    // allows the user to manipulate the camera
    scnView.allowsCameraControl = YES;
    
    // show statistics such as fps and timing information
    scnView.showsStatistics = YES;
    
    // configure the view
    scnView.backgroundColor = [UIColor blackColor];
    
    // add a tap gesture recognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    [gestureRecognizers addObject:tapGesture];
    [gestureRecognizers addObjectsFromArray:scnView.gestureRecognizers];
    scnView.gestureRecognizers = gestureRecognizers;
}




- (void)handleTap:(UIGestureRecognizer*)gestureRecognize {
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    // check what nodes are tapped
    CGPoint p = [gestureRecognize locationInView:scnView];
    NSArray *hitResults = [scnView hitTest:p options:nil];
    
    // check that we clicked on at least one object
    if([hitResults count] > 0){
        // retrieved the first clicked object
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        
        // get its material
        SCNMaterial *material = result.node.geometry.firstMaterial;
        
        // highlight it
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:0.5];
        
        // on completion - unhighlight
        [SCNTransaction setCompletionBlock:^{
            [SCNTransaction begin];
            [SCNTransaction setAnimationDuration:0.5];
            
            material.emission.contents = [UIColor blackColor];
            
            [SCNTransaction commit];
        }];
        
        material.emission.contents = [UIColor redColor];
        
        [SCNTransaction commit];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end