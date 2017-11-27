//
//  SCNviewControllerViewController.m
//  AR-SolarSystem
//
//  Created by 龙行天下 on 2017/8/8.
//  Copyright © 2017年 龙行天下. All rights reserved.
//

#import "SCNviewControllerViewController.h"

//3D游戏框架
#import <SceneKit/SceneKit.h>
//arKit 框架
#import <ARKit/ARKit.h>

@interface SCNviewControllerViewController () <ARSCNViewDelegate,ARSessionDelegate>

//AR视图 用于展示3d界面
@property (nonatomic,strong) ARSCNView *arSCNView;
//负责ar会话 ，管理相机和追踪位置
@property (nonatomic,strong) ARSession *arSession;
//配置追踪 y
@property(nonatomic,strong) NSURLSessionConfiguration *arSessionConfiguration;

//创建节点对象

@property (nonatomic,strong) SCNNode *sunNode;
@property (nonatomic,strong) SCNNode *earthNode;
@property (nonatomic,strong) SCNNode *moonNode;
@property (nonatomic,strong) SCNNode *marsNode;
@property (nonatomic,strong) SCNNode *mercuryNode; //水星
@property (nonatomic,strong) SCNNode *venusNode;    //金星
@property (nonatomic,strong) SCNNode *jupiterNode; //木星
@property (nonatomic,strong) SCNNode *jupiterNodeLoop; // 木星环
@property (nonatomic,strong) SCNNode *jupiterNodeGroupLoop; //木星环组
@property (nonatomic,strong) SCNNode *saturnNode;  //土星
@property (nonatomic,strong) SCNNode *saturnLoopNode; //土星环
@property (nonatomic,strong) SCNNode *saturnNodeGroupLoop; //土星环组
@property (nonatomic,strong) SCNNode *uransNode ; // 天王星
@property (nonatomic,strong) SCNNode *uransNodeLoop; //天王星环
@property (nonatomic,strong) SCNNode *uransNodeGroupLoop;// 天王星环组
@property (nonatomic,strong) SCNNode *neptuneNode; //海王星
@property (nonatomic,strong) SCNNode *neptuneLoopNode; //海王星环
@property (nonatomic,strong) SCNNode *neptuneNodeGroupLoop;  //海王星group
@property (nonatomic,strong) SCNNode *plutoNode;//  冥王星
@property (nonatomic,strong) SCNNode *earthGroupNode;
@property (nonatomic,strong) SCNNode *sunHaloNode;

@end

@implementation SCNviewControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    
    [self.view addSubview: self.arSCNView];
    
    self.arSCNView.delegate = self;
    
    [self.arSession runWithConfiguration:self.arSessionConfiguration];
    
}
//懒加载
-(ARSCNView *)arSCNView
{
    if (_arSCNView != nil) {
        
        return _arSCNView;
    }
    _arSCNView = [[ARSCNView alloc]initWithFrame:self.view.bounds];
    _arSCNView.session = self.arSession;
    _arSCNView.automaticallyUpdatesLighting = YES;
    _arSCNView.delegate = self;
    
    //初始化节点
    [self initNode];
    
    return _arSCNView;
}

-(ARSession *)arSession{
    
    if (_arSession != nil) {
        return _arSession;
    }
    
    _arSession = [[ARSession alloc] init];
    
    _arSession.delegate = self;
    
    
    
    return  _arSession;
}

-(NSURLSessionConfiguration *)arSessionConfiguration
{
    if (_arSessionConfiguration != nil) {
        return  _arSessionConfiguration;
    }
    
    //创建世界追踪会话配置  （使用ARWorldTrackingSessionConfiguration 效果更好）
    ARWorldTrackingConfiguration *configuration = [[ARWorldTrackingConfiguration alloc]init];
    
    //设置追踪的方向 （）追踪平面
    configuration.planeDetection = ARPlaneDetectionHorizontal;
    
    //灯光自适应
    configuration.lightEstimationEnabled = YES;
    
    _arSessionConfiguration = configuration;
    
   
    
    return _arSessionConfiguration;
}
-(void)initNode{
    
    //y用代码创建节点
    _sunNode = [[SCNNode alloc]init];
    _mercuryNode = [[SCNNode alloc]init];
    _venusNode = [[SCNNode alloc]init];
    _earthNode = [[SCNNode alloc]init];
    _moonNode = [[SCNNode alloc] init];
    _marsNode = [[SCNNode alloc]init];
    _earthGroupNode = [SCNNode new];
    _jupiterNode = [SCNNode new];
    _saturnNode = [SCNNode new];
    _saturnLoopNode = [SCNNode new];
    _saturnNodeGroupLoop = [SCNNode new];
    _uransNode = [SCNNode new];
    _neptuneNode = [SCNNode new];
    _plutoNode = [SCNNode new];
    
    _sunNode.geometry = [SCNSphere sphereWithRadius:0.5];
    _mercuryNode.geometry = [SCNSphere sphereWithRadius:0.04];
    _venusNode.geometry = [SCNSphere sphereWithRadius:0.08];
    _marsNode.geometry = [SCNSphere sphereWithRadius:0.06];
    _earthNode.geometry = [SCNSphere sphereWithRadius:0.10];
    _moonNode.geometry = [SCNSphere sphereWithRadius:0.02];
    _jupiterNode.geometry = [SCNSphere sphereWithRadius:0.3];
    _saturnNode.geometry = [SCNSphere sphereWithRadius:0.24];
    _uransNode.geometry = [SCNSphere sphereWithRadius:0.18];
    _neptuneNode.geometry = [SCNSphere sphereWithRadius:0.16];
    _plutoNode.geometry = [SCNSphere sphereWithRadius:0.08];
    
    _moonNode.position = SCNVector3Make(0.2, 0, 0);
    
    [_earthGroupNode addChildNode:_earthNode];
    [_saturnNodeGroupLoop addChildNode:_saturnNode];
    
    
    //添加土星环
    SCNNode *satunLoopNode = [SCNNode new];
    satunLoopNode.opacity = 0.4;
    satunLoopNode.geometry = [SCNBox boxWithWidth:1.2 height:0 length:1.2 chamferRadius:0];
    satunLoopNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/saturn_loop.png";
    satunLoopNode.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    satunLoopNode.rotation = SCNVector4Make(-0.5, -1, 9, M_PI_2);
    satunLoopNode.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant;
    
    [_saturnNodeGroupLoop addChildNode:satunLoopNode];
    
    _mercuryNode.position = SCNVector3Make(0.8, 0, 0);
    _venusNode.position = SCNVector3Make(1.2, 0, 0);
    _earthGroupNode.position = SCNVector3Make(1.6, 0, 0);
    _marsNode.position = SCNVector3Make(2.0, 0, 0);
    _jupiterNode.position = SCNVector3Make(2.8, 0, 0);
    _saturnNodeGroupLoop.position = SCNVector3Make(3.36, 0, 0);
    _uransNode.position = SCNVector3Make(3.9, 0, 0 );
    _neptuneNode.position = SCNVector3Make(4.28, 0, 0);
    _plutoNode.position = SCNVector3Make(4.638, 0, 0);
    
    //设置太阳的位置坐标
    [_sunNode setPosition:SCNVector3Make(0, -0.1, 3)];
    
    [self.arSCNView.scene.rootNode addChildNode:_sunNode];
    
    //水星贴图
    _mercuryNode.geometry.firstMaterial.diffuse.contents =  @"art.scnassets/earth/mercury.jpg";
    //金星贴图
    _venusNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/venus.jpg";
    //火星贴图
    _marsNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/mars.jpg";
    
    //地球贴图
    _earthNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/earth-diffuse-mini.jpg";
    _earthNode.geometry.firstMaterial.emission.contents = @"art.scnassets/earth/earth-emissive-mini.jpg";
    _earthNode.geometry.firstMaterial.specular.contents = @"art.scnassets/earth/earth-specular-mini.jpg";
    
    //月球贴图
    _moonNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/moon.jpg";
    
    //木星贴图
    _jupiterNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/jupiter.jpg";
    //土星铁如
    _saturnNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/saturn.jpg";
    //天王星
    _uransNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/uranus.jpg";
    //海王星
    _neptuneNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/neptune.jpg";
    //冥王星
    _plutoNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/pluto.jpg";
    
    
    //太阳贴图
    _sunNode.geometry.firstMaterial.multiply.contents = @"art.scnassets/earth/sun.jpg";
    _sunNode.geometry.firstMaterial.diffuse.contents= @"art.scnassets/earth/sun.jpg";
    _sunNode.geometry.firstMaterial.multiply.intensity = 0.5;
    _sunNode.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant;
    
    _sunNode.geometry.firstMaterial.multiply.wrapS =
    _sunNode.geometry.firstMaterial.diffuse.wrapS  =
    _sunNode.geometry.firstMaterial.multiply.wrapT =
    _sunNode.geometry.firstMaterial.diffuse.wrapT  = SCNWrapModeRepeat;
    
    
    
    
    _mercuryNode.geometry.firstMaterial.locksAmbientWithDiffuse =
    _venusNode.geometry.firstMaterial.locksAmbientWithDiffuse =
    _marsNode.geometry.firstMaterial.locksAmbientWithDiffuse =
    _earthNode.geometry.firstMaterial.locksAmbientWithDiffuse =
    _moonNode.geometry.firstMaterial.locksAmbientWithDiffuse  =
    _jupiterNode.geometry.firstMaterial.locksAmbientWithDiffuse  =
    _saturnNode.geometry.firstMaterial.locksAmbientWithDiffuse  =
    _uransNode.geometry.firstMaterial.locksAmbientWithDiffuse  =
    _neptuneNode.geometry.firstMaterial.locksAmbientWithDiffuse  =
    _plutoNode.geometry.firstMaterial.locksAmbientWithDiffuse  =
    _sunNode.geometry.firstMaterial.locksAmbientWithDiffuse   = YES;
    
    
    _mercuryNode.geometry.firstMaterial.shininess =
    _venusNode.geometry.firstMaterial.shininess =
    _earthNode.geometry.firstMaterial.shininess =
    _moonNode.geometry.firstMaterial.shininess =
    _marsNode.geometry.firstMaterial.shininess =
    _jupiterNode.geometry.firstMaterial.shininess =
    _saturnNode.geometry.firstMaterial.shininess =
    _uransNode.geometry.firstMaterial.shininess =
    _neptuneNode.geometry.firstMaterial.shininess =
    _plutoNode.geometry.firstMaterial.shininess = 0.1;
    
    
    _mercuryNode.geometry.firstMaterial.specular.intensity =
    _venusNode.geometry.firstMaterial.specular.intensity =
    _earthNode.geometry.firstMaterial.specular.intensity =
    _moonNode.geometry.firstMaterial.specular.intensity =
    _marsNode.geometry.firstMaterial.specular.intensity =
    _jupiterNode.geometry.firstMaterial.specular.intensity =
    _saturnNode.geometry.firstMaterial.specular.intensity =
    _uransNode.geometry.firstMaterial.specular.intensity =
    _neptuneNode.geometry.firstMaterial.specular.intensity =
    _plutoNode.geometry.firstMaterial.specular.intensity =
    _marsNode.geometry.firstMaterial.specular.intensity = 0.5;
    
    _moonNode.geometry.firstMaterial.specular.contents = [UIColor grayColor];
    
    [self roationNode];
    [self addOtherNode];
    [self addLight];
}

-(void)roationNode{
    
    [_earthNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];  //地球自转
    
    //moon 月球自转
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 1.5;
    animation.toValue = [NSValue  valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI *2)];
    animation.repeatCount = FLT_MAX;
    [_moonNode addAnimation:animation forKey:@"moon rotation"];
    
    //月球公转
    SCNNode * moonRotationNode = [SCNNode node];
    [moonRotationNode addChildNode:_moonNode];
    
    CABasicAnimation *moonRotationAnimation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    moonRotationAnimation.duration = 15.0;
    moonRotationAnimation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI*2)];
    moonRotationAnimation.repeatCount = FLT_MAX;
    [moonRotationNode addAnimation:animation forKey:@"moon rotation around earth"];
    
    [_earthGroupNode addChildNode:moonRotationNode];
    
    //地球旋转  围绕太阳
    SCNNode *earthRoatationNode = [SCNNode node];
    [_sunNode addChildNode:earthRoatationNode];
    
    [earthRoatationNode addChildNode:_earthGroupNode];
    
    //地球围绕太阳转
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 30.0;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI *2 )];
    animation.repeatCount = FLT_MAX;
    [earthRoatationNode addAnimation:animation forKey:@"earth rotation around sun"];
    
    
    [_mercuryNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    [_venusNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    [_marsNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    [_jupiterNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    [_saturnNode runAction: [SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    [_uransNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    [_neptuneNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    [_plutoNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    
    [_saturnNodeGroupLoop addChildNode:_saturnNode];
    
    SCNNode *mercRotationNode = [SCNNode node];
    [mercRotationNode addChildNode:_mercuryNode];
    [_sunNode addChildNode:mercRotationNode];
    
    SCNNode *venusRotationNode = [SCNNode node];
    [venusRotationNode addChildNode:_venusNode];
    [_sunNode addChildNode:venusRotationNode];
    
    SCNNode *marsRotationNode = [SCNNode node];
    [marsRotationNode addChildNode:_marsNode];
    [_sunNode addChildNode:marsRotationNode];
    
    
    SCNNode *juiterRotationNode = [SCNNode node];
    [juiterRotationNode addChildNode:_jupiterNode];
    [_sunNode addChildNode:juiterRotationNode];
    
    
    SCNNode *saturnRotationNode = [SCNNode node];
    [saturnRotationNode addChildNode:_saturnNodeGroupLoop];
    [_sunNode addChildNode:saturnRotationNode];
    
    SCNNode *uransRotationNode = [SCNNode node];
    [uransRotationNode addChildNode:_uransNode];
    [_sunNode addChildNode:uransRotationNode];
    
    
    SCNNode *neptuneRotationNode = [SCNNode node];
    [neptuneRotationNode addChildNode:_neptuneNode];
    [_sunNode addChildNode:neptuneRotationNode];
    
    SCNNode *plutoRotationNode = [SCNNode node];
    [plutoRotationNode addChildNode:_plutoNode];
    [_sunNode addChildNode: plutoRotationNode];
    
    
    //Rotate  the Mercury around the sun
    
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 25.0;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI *2 )];
    animation.repeatCount = FLT_MAX;
    [mercRotationNode addAnimation:animation forKey:@"mercurt rotation around sun"];
    [_sunNode addChildNode:mercRotationNode];
    
    
    //Rotate the venus around sun
    
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 40.0;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI *2)];
    animation.repeatCount = FLT_MAX;
    [venusRotationNode addAnimation:animation forKey:@"venus rotation around sun"];
    [_sunNode addChildNode:venusRotationNode];
    
    
    //ROtate the Mars around the sun
    
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 35.0;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    animation.repeatCount = FLT_MAX;
    [marsRotationNode addAnimation:animation forKey:@"Mars rotation around sun"];
    
    
    //Rotate the jupiter around the sun
    
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 90.0;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI *2)];
    animation.repeatCount = FLT_MAX;
    [juiterRotationNode addAnimation:animation forKey:@"jupiter rotation around sun"];
    [_sunNode addChildNode:juiterRotationNode];
    
    //Rotate the Saturn around the sun
    
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 80.0;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI *2 )];
    animation.repeatCount = FLT_MAX;
    [saturnRotationNode addAnimation:animation  forKey:@"mars rotation around sun"];
    [_sunNode addChildNode:saturnRotationNode];
    
    
    //Rotate the uranus around the sun
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 55.0;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    [uransRotationNode addAnimation:animation forKey:@"urans rotation around the sun"];
    [_sunNode addChildNode:uransRotationNode];
    
    
    //Rotate ethe  Neptune around the sun
    animation = [CABasicAnimation animationWithKeyPath:@"rotaion"];
    animation.duration = 50.0;
    animation.repeatCount = FLT_MAX;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI *2)];
    [neptuneRotationNode addAnimation:animation forKey:@"neptune rotation around the sun"];
    [_sunNode addChildNode:neptuneRotationNode];
    
    
    
    //Rotate the pluto around the sun
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 100.0;
    animation.repeatCount = FLT_MAX;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI *2)];
    
    [plutoRotationNode addAnimation:animation forKey:@"rotation"];
    [_sunNode addChildNode:plutoRotationNode];
    
    [self addAnimationToSUN];
    
    
    
    
    
    
    
}
-(void)addAnimationToSUN{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"contentsTransfORM"];
    animation.duration = 10.0;
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(0, 0, 0), CATransform3DMakeScale(3, 3, 3))];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(1, 0, 0), CATransform3DMakeScale(3, 3, 3))];
    
    animation.repeatCount = FLT_MAX;
    [_sunNode.geometry.firstMaterial.diffuse addAnimation:animation forKey:@"sun-texture"];
    
    animation = [CABasicAnimation animationWithKeyPath:@"contentsTransform"];
    animation.duration = 30.0;
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(0, 0, 0), CATransform3DMakeScale(5, 5, 5 ))];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(1, 0, 0), CATransform3DMakeScale(5, 5, 5  ))];
    animation.repeatCount = FLT_MAX;
    [_sunNode.geometry.firstMaterial.multiply addAnimation:animation forKey:@"sun0-texture2"];
    
    
    
    
}
-(void)addOtherNode{
    
    SCNNode *cloudsNode = [SCNNode node];
    cloudsNode.geometry = [SCNSphere sphereWithRadius:0.12];
    [_earthNode addChildNode:cloudsNode];
    
    cloudsNode.opacity = 0.5;
    
    //
    cloudsNode.geometry.firstMaterial.transparent.contents = @"art.scnassets/earth/cloudsTransparency.png";
    cloudsNode.geometry.firstMaterial.transparencyMode = SCNTransparencyModeRGBZero;
    
    //add a halo(光晕)
    _sunHaloNode = [SCNNode node];
    _sunHaloNode.geometry = [SCNPlane planeWithWidth:5 height:5];
    _sunHaloNode.rotation = SCNVector4Make(1, 0, 0,  0 * M_PI /180);
    _sunHaloNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/sun-halo.png";
    _sunHaloNode.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant;
    _sunHaloNode.geometry.firstMaterial.writesToDepthBuffer = NO; //不进行深度渲染
    
    _sunHaloNode.opacity = 0.2;
    [_sunNode addChildNode:_sunHaloNode];
    
    
    //add a texture plane to represent mercury' orbit
    
    SCNNode *mercuryOrbit = [SCNNode node];
    mercuryOrbit.opacity = 0.4;
    mercuryOrbit.geometry = [SCNBox boxWithWidth:1.72 height:0 length:1.72 chamferRadius:0];
    mercuryOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    mercuryOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    mercuryOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    mercuryOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant;   //no light
    [_sunNode addChildNode:mercuryOrbit];
    
    
    //add a texture plane to represent venus' orbit
    SCNNode *venusOrbit = [SCNNode node];
    venusOrbit.opacity = 0.4;
    venusOrbit.geometry = [SCNBox boxWithWidth:2.58 height:0 length:2.58 chamferRadius:0];
    venusOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    venusOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    venusOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    venusOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant;
    [_sunNode addChildNode:venusOrbit];
    
    //add a text plane to represent Earth' orbit
    
    SCNNode *earthOrbit = [SCNNode node];
    earthOrbit.opacity = 0.4;
    earthOrbit.geometry = [SCNBox boxWithWidth:3.44 height:0 length:3.44 chamferRadius:0];
    earthOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    earthOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    earthOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    earthOrbit.geometry.firstMaterial.lightingModelName  = SCNLightingModelConstant;
    [_sunNode addChildNode:earthOrbit];
    
    //add textture  plane to  represnet mars orbirt
    SCNNode *marsOrbit = [SCNNode node];
    marsOrbit.opacity = 0.4;
    marsOrbit.geometry  = [SCNBox boxWithWidth:4.28 height:0 length:4.28 chamferRadius:0];
    marsOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    marsOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    marsOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    marsOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant;
    [_sunNode addChildNode:marsOrbit];
    
    //add texture plane to  represent jupiter orbit
    SCNNode *jupiterOrbit = [SCNNode node];
    jupiterOrbit.opacity = 0.4;
    jupiterOrbit.geometry = [SCNBox boxWithWidth:5.9 height:0 length:5.9 chamferRadius:0];
    jupiterOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    jupiterOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    jupiterOrbit.rotation  = SCNVector4Make(0, 1, 0, M_PI_2);
    jupiterOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant;
    [_sunNode addChildNode:jupiterOrbit];
    
    
    //add a texture plane to represent satun' orbit
    
    SCNNode *saturnOrbit = [SCNNode node];
    saturnOrbit.opacity = 0.4;
    saturnOrbit.geometry = [SCNBox boxWithWidth:7.14 height:0 length:7.14 chamferRadius:0];
    saturnOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    saturnOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    saturnOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    saturnOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant;
    [_sunNode addChildNode:saturnOrbit];
    
    //add  a texture plane to represnt uranus' orbit
    
    SCNNode *uranusOrbit = [SCNNode node];
    uranusOrbit.opacity = 0.4;
    uranusOrbit.geometry = [SCNBox boxWithWidth:8.4 height:0 length:8.4 chamferRadius:0];
    uranusOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    uranusOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    uranusOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    uranusOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant;
    [_sunNode addChildNode:uranusOrbit];
    
    // add  a texture plane to represent neptune's orbit
    
    SCNNode *neptuneOrbit = [SCNNode node];
    neptuneOrbit.opacity  = 0.4;
    neptuneOrbit.geometry = [SCNBox boxWithWidth:9.08 height:0 length:9.08 chamferRadius:0];
    neptuneOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    neptuneOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    neptuneOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    neptuneOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant;
    [_sunNode addChildNode:neptuneOrbit];
    
    //add atexture  plane to represnt plute's orbit
    
    SCNNode *pluteOrbit = [SCNNode node];
    pluteOrbit.opacity = 0.4;
    pluteOrbit.geometry = [SCNBox boxWithWidth:10 height:0 length:10 chamferRadius:0];
    pluteOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    pluteOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    pluteOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    pluteOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant;
    [_sunNode addChildNode:neptuneOrbit];
    
}


//添加灯光
-(void)addLight{
    
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.color = [UIColor blackColor];
    lightNode.light.type =SCNLightTypeOmni;
    [_sunNode addChildNode:lightNode];
    
    
    //configure attention distances because we dont want to light the floor
    lightNode.light.attenuationEndDistance = 19;
    lightNode.light.attenuationStartDistance = 21;
    
    //animation
    
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:1];
    {
        lightNode.light.color = [UIColor whiteColor];
        _sunHaloNode.opacity = 0.5;
    }
    
    [SCNTransaction commit];
    
    
    
}

#pragma  mark -- ARSessionDelegate

-(void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame
{
    
    //坚监听手机的移动，实现近距离查看太阳细节。 凸显效果变化值*3
    [_sunNode setPosition:SCNVector3Make(-3 *frame.camera.transform.columns[3].x, -0.1 - 3*frame.camera.transform.columns[3].y, -2 - 3 *frame.camera.transform.columns[3].z)];
    
    
}


@end
