#import <Foundation/Foundation.h>
#import "SPLabel.h"
#import "SIAlertView.h"
#import "AFURLSessionManager.h"
#import "AFHTTPRequestOperationManager.h"
#import <AFHTTPSessionManager.h>
#import <RESideMenu.h>
#import <sys/utsname.h>
#import "Reachability.h"
#import "NOChatViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "NSDate+Helper.h"
#import "NOMenuIzquierdaViewController.h"

#define RGB(r, g, b) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:1.0]
#define RGBA(r, g, b, a) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:a]
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface SPUtilidades : NSObject
// Comprueba si la cadena está vacía
+(BOOL) isEmpty:(NSString *) string;

+(CGFloat) TamanyoTexto: (NSString *) texto
                Tamanyo: (CGSize) tamanyo
                 Fuente: (UIFont *) fuente;

+(CGFloat) AnchuraTexto: (NSString *) texto
                Tamanyo: (CGSize) tamanyo
                 Fuente: (UIFont *) fuente;

// Devuelve el nombre del día
+(NSString *) nombreDia: (int) dia;

// Devuelve el nombre del mes
+(NSString *) nombreMes: (int) mes;
+(NSString *) nombreMesCompleto: (int) mes;

// Establece el background de una vista
+(void) setBackground: (NSString *) fondo
             Posicion: (int) posicion
                Vista: (UIView *) vista
                Alpha: (float) alpha;

// Crea un campo estático
+(void) setTextoEstatico:(CGRect) frame
                   Texto:(NSString *) texto
                  Fuente:(UIFont *) fuente
               TextColor:(UIColor *) color
                   Padre:(UIView *) padre
               Alignment:(NSTextAlignment) alineacion;

// Crea un campo estático
+(SPLabel *) setTextoEstaticoRtn:(CGRect) frame
                           Texto:(NSString *) texto
                          Fuente:(UIFont *) fuente
                       TextColor:(UIColor *) color
                           Padre:(UIView *) padre
                       Alignment:(NSTextAlignment) alineacion;

// Establece una máscara a una imagen
+(UIImage *) maskImage:(UIImage *) image
              withMask:(UIImage *) maskImage;

// Redimensiona una imagen
+(UIImage *) imageWithImage:(UIImage *) image
               scaledToSize:(CGSize) newSize;

// Crea un botón con imagen
+(UIButton *) buttonWithButton:(CGRect) frame
                        Titulo:(NSString *) titulo
                          Font:(UIFont *) font
                        Imagen:(NSString *) imagen
                    SizeImagen:(CGSize) sizeimagen
               TitleEdgeInsets:(UIEdgeInsets) titleedgeinsets
               ImageEdgeInsets:(UIEdgeInsets) imageedgeinsets;

// Establece una imagen a un botón
+(void) setImagenBoton:(UIButton *) boton
                 Image:(NSString *) imagen
            SizeImagen:(CGSize) sizeimagen;

// Crea un UIImage a partir de un color
+ (UIImage *)imageWithColor:(UIColor *)color;

// Desactiva el menú
+(void) desactivarMenu;

// Activa el menú
+(void) activarMenu;

// Devuelve el menú
+(RESideMenu *) getResideMenu;

// Devuelve el navegador de controladores
+(UINavigationController *) getNavigationController;

// Encuentra la ventana de un chat
+(UIViewController *) encontrarChat: (NSNumber *) codigo;

// Carga una vista como actividad principal
+(void) cargarRootUIViewController: (UIViewController *) vista;

// Crea la barra de navegación
+(UILabel *) crearBarraNavegacion: (UIViewController *) vista
                           Titulo: (NSString *) titulo
                    MenuIzquierdo: (BOOL) menuizquierdo
                      MenuDerecho: (BOOL) menuderecho
                SelectorIzquierdo: (SEL) selector;

// Crea la barra de navegación
+(UILabel *) crearBarraNavegacion: (UIViewController *) vista
                           Titulo: (NSString *) titulo
                    MenuIzquierdo: (BOOL) menuizquierdo
                      MenuDerecho: (BOOL) menuderecho;

// Muestra un mensaje de error
+(void) mostrarError:(NSString *) titulo
             Mensaje:(NSString *) mensaje
             Handler:(SIAlertViewHandler) manejador;

// Muestra un mensaje de error
+(void) mostrarError:(NSString *) titulo
             Mensaje:(NSString *) mensaje
             Handler:(SIAlertViewHandler) manejador
             Retraso:(BOOL) delay;

// Muestra un mensaje de información
+(void) mostrarInformacion:(NSString *) titulo
                   Mensaje:(NSString *) mensaje
                   Handler:(SIAlertViewHandler) manejador;

// Política de seguridad SSL
+(AFSecurityPolicy*) politicaSeguridadSSL: (NSString *) archivo;

// Realiza una petición GET
+(AFHTTPSessionManager *) procesarPeticionGET: (NSString *) url
                                 SuccessBlock: (void (^)(id responseObject)) exito
                                 FailureBlock: (void (^)(NSError *error)) fallo;

// Realiza una petición POST
+(AFHTTPSessionManager *) procesarPeticionPOST: (NSString *) url
                                    Parametros: (NSDictionary *) parametros
                                  SuccessBlock: (void (^)(id responseObject)) exito
                                  FailureBlock: (void (^)(NSError *error)) fallo;

// Obtiene la URL para una imagen
+(NSURL *) urlImagenes: (NSString *) tipo
                Imagen: (NSString *) imagen;

// Guarda una imagen un directorio
+(void) guardarImagen: (NSString *) directorio
              Archivo: (NSString *) archivo
                Datos: (NSData *) datos;

// Guarda los datos de APN
+(void) guardarDatosAPN: (NSString *) apn;

// Lee una imagen desde un archivo
+(UIImage*) leerImagen: (NSString *) directorio
               Archivo: (NSString *) archivo;

// Comprueba si existe una imagen
+(BOOL) existeImagen: (NSString *) directorio
             Archivo: (NSString *) archivo;

// Elimina una imagen
+(void) eliminarImagen: (NSString *) directorio
               Archivo: (NSString *) archivo;

// Eliminamos el directorio
+(void) eliminarDirectorio: (NSString *) directorio;

// Plataforma
+(NSString *) plataformaIOS;

// Guarda los datos del usuario
+(void) guardarDatosUsuario: (NSString *) nombre
                      Token: (NSString *) token
                     Imagen: (NSString *) imagen;

// Guarda los datos de la fecha del chat
+(void) guardarFechaChats: (NSString *) fecha;

// Lee los datos del usuario guardado
+(NSString *) leerDatosUsuario;
+(NSString *) leerDatosToken;
+(NSString *) leerDatosImagen;
+(NSString *) leerDatosAPN;
+(NSString *) leerFechaChats;

// Convierte un NSString a un NSDate
+(NSDate *) NSStringToNSDate: (NSString *) fecha
                     Formato: (NSString *) formato;

// Comprueba si está conectado a Internet
+(BOOL) conectadoInternet;

// Combina dos imágenes
+(UIImage*) combinarImagen: (UIImage *) firstImage
                 withImage: (UIImage *) secondImage
                  Position: (CGPoint) posicion;

// Crea un marcador para un mapa
+(UIImage *) crearMarcador: (UIImage *) imagen;

// Registramos el APN
+(void) registrarAPN;

// Refresca el menú
+(void) refrescarMenu;
@end
