//
//  DetalleAlbumViewController.m
//  Luis Ramiro
//
//  Created by Ivan on 10/04/14.
//  Copyright (c) 2014 Ivan. All rights reserved.
//

#import "DetalleAlbumViewController.h"
#import "VistaReproductorCancion.h"
#import "VistaReproductorViewController.h"

@interface DetalleAlbumViewController ()

@end

@implementation DetalleAlbumViewController

@synthesize Album;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.Album.aCanciones=[self.Album CargarCanciones];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [self.Album.aCanciones count];
    //return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	static NSString *CellIdentifier = @"Cell";
    
    
    // Try to retrieve from the table view a now-unused cell with the given identifier.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // If no cell is available, create a new one using the given identifier.
    if (cell == nil) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    Cancion *cancion=[Album.aCanciones objectAtIndex:indexPath.row];

    

	
	// Configure the cell.
    NSString *titulo= [NSString stringWithFormat:@"%@ - %@",cancion.ID_Cancion,cancion.Titulo];

    
    
    //Sacamos la imagen
    /*
    NSURL *url=[NSURL URLWithString:Album.Url_Imagen];

    NSData *data=Nil;
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory=[paths objectAtIndex:0];
    
    
    NSString *nombreFichero = [[[self.Album.Url_Imagen stringByReplacingOccurrencesOfString:@"/"withString:@"_"]stringByReplacingOccurrencesOfString:@":" withString:@"_"]stringByReplacingOccurrencesOfString:@"www." withString:@"www_"];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/%@",cachesDirectory,nombreFichero];
    NSFileManager *gestorArchivos = [NSFileManager defaultManager];
    NSString *rutaArchivoImagen = @"";
    
   
    rutaArchivoImagen = [NSString stringWithFormat:@"%@/%@",cachesDirectory,nombreFichero];
    
    if (![gestorArchivos fileExistsAtPath: rutaArchivoImagen])
    {
        
        data = [NSData dataWithContentsOfURL:url];
        [data writeToFile:fileName atomically:TRUE];
        NSLog(@"grabando la imagen");
    }
    else
    {
        data = [NSData dataWithContentsOfFile:rutaArchivoImagen];
        
        NSLog(@"Ya teniamos la imagen");
    }
     */
    //[self.dataArray addObject:nombreFichero];
    //  [self.dataArray addObject:rutaArchivoImagen];
    
    
	//Poner la celda transparente [cell setBackgroundColor:[UIColor clearColor]];
    
    
    //  NSString *subtitulo=[NSString stringWithFormat:@"%@ - %@",fecha_actividad, poema.Poema];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.text= titulo;
    cell.textLabel.font=[UIFont fontWithName:@"YanoneKaffeesatz-Regular" size:14.0];
    //  cell.detailTextLabel.text=subtitulo;
    cell.detailTextLabel.font=[UIFont fontWithName:@"YanoneKaffeesatz-Regular" size:13.0];
    //cell.imageView.image=[UIImage imageNamed:@"808-documents.png"];
    
    //modificacion 20140613: el cliente no quiere que se muestra la imagen del disco en la lista
    //     cell.imageView.image=[UIImage imageWithData:data];

    // fin modificacion

    
    // cell.imageView.layer.cornerRadius = 5.0;
    // cell.imageView.layer.masksToBounds = YES;
    // cell.imageView.layer.borderColor = [UIColor brownColor].CGColor;
    // cell.imageView.layer.borderWidth = 2.0;
    
    cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton; //boton a la izquierda
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator; //flecha a la izquierda
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (CGFloat)tableView: (UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//Devuelve la altura de la fila
    
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Navigation logic may go here. Create and push another view controller.
 
    
    Cancion *cancion=[Album.aCanciones objectAtIndex:indexPath.row];
    
    if (![cancion.Enlace isEqualToString:@""])
          {
             // VistaReproductorCancion *vrc=[self.storyboard instantiateViewControllerWithIdentifier:@"ReproductorCancion"];
              
              VistaReproductorViewController *vrc=[self.storyboard instantiateViewControllerWithIdentifier:@"Reproductor"];

              //vrc.url=cancion.Enlace;
              
              if (![[cancion.Enlace substringWithRange:NSMakeRange(0,4)] isEqualToString:@"http"])
              {
                  cancion.Enlace = [NSString stringWithFormat:@"http://%@", cancion.Enlace];
              }
            
              
              
              appDelegate.url_cancion_actual=cancion.Enlace;
              

              vrc.Album=Album;
              vrc.Cancion=cancion;
              vrc.Num_Pista=indexPath.row;
             // vrc.Num_cancion=indexPath.row;
              
              [self.navigationController pushViewController:vrc animated:YES];
              
              
              
              
              
  
          }
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */



@end


