#include <stdlib.h>
#include <stdio.h>
#include <GL/glut.h>
//#include <GL/glx.h>

/* dimensions de la fenetre */
int width = 600;
int height = 400;

#define MAX_POINTS 100
typedef struct
{
	float x, y;
} Point;
int nbPoints = 0;
typedef Point Vecteur[MAX_POINTS];
Vecteur poly;
int indexDragged=-1;
double tStep=0.025;

/*************************************************************************/
/* Bezier */
/*************************************************************************/

Point Bezier(double t)
{
	if(nbPoints==0)
	{
		Point p;
		p.x=0;
		p.y=0;
		return p;
	}
	int i, nbPointsInterpolate=nbPoints;
	Point VectorInterpolate[MAX_POINTS];
	for(i=0; i<nbPointsInterpolate; ++i)
	{
		VectorInterpolate[i]=poly[i];
	}
	while(--nbPointsInterpolate > 0)
	{
		for(i=0; i<nbPointsInterpolate; ++i)
		{
			VectorInterpolate[i].x=t*VectorInterpolate[i].x+(1-t)*VectorInterpolate[i+1].x;
			VectorInterpolate[i].y=t*VectorInterpolate[i].y+(1-t)*VectorInterpolate[i+1].y;
		}
	}
	return VectorInterpolate[0];
}

/*************************************************************************/
/* Fonctions de dessin */
/*************************************************************************/

/* rouge vert bleu entre 0 et 1 */
void chooseColor(double r, double g, double b)
{
	glColor3d(r,g,b);
}

void drawPoint(double x, double  y)
{
	glBegin(GL_POINTS);
	glVertex2d(x,y);
	glEnd();
}

void drawLine(double x1, double  y1, double x2, double y2)
{
	glBegin(GL_LINES);
	glVertex2d(x1,y1);
	glVertex2d(x2,y2);
	glEnd();
}


/*************************************************************************/
/* Fonctions callback */
/*************************************************************************/

void display()
{
	int i;
	glClear(GL_COLOR_BUFFER_BIT);

	// tracé du polygone de controle
	chooseColor(1,1,1);
	if (nbPoints == 1) 
		drawPoint(poly[0].x, poly[0].y);
	else if (nbPoints > 1) 
	{
		for (i=0;i<nbPoints-1;i++)
			drawLine(poly[i].x, poly[i].y, poly[i+1].x, poly[i+1].y);
	}
	// ** Dessiner ici ! **
	Point pointBezier;
	chooseColor(1,0.2,0.2);
	double t;
	for(t=0; t<=1; t+=tStep)
	{
		pointBezier=Bezier(t);
		drawPoint(pointBezier.x, pointBezier.y);
	}

	glutSwapBuffers();
}

void keyboard(unsigned char keycode, int x, int y)
{
	/* touche ECHAP */
	if (keycode==27)
		exit(0);
	/* touche ECHAP */
	if (keycode=='z')
		tStep+=tStep;
	if(keycode=='s' && tStep>0.001)
		tStep/=2.0;
	glutPostRedisplay();
}

void reshape(int w, int h)
{
	width=w;
	height=h;
	glViewport(0, 0, w, h);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluOrtho2D( 0, w, h, 0);
	glMatrixMode(GL_MODELVIEW);
}

/* Evenement : clic souris */
void mouse(int button, int state, int x, int y)
{
	int i;
	if (button == GLUT_LEFT_BUTTON && state == GLUT_DOWN)
	{
		printf("Left clic at %d %d\n",x,y);
		poly[nbPoints].x = x;
		poly[nbPoints].y = y;
		nbPoints++;
		glutPostRedisplay();
	}
	else if(button == GLUT_RIGHT_BUTTON && state==GLUT_DOWN)
	{
		printf("Right clic at %d %d\n",x,y);
		for(i=0;i<nbPoints && indexDragged==-1;++i)
		{
			if(poly[i].x-x < 5.0f && poly[i].x-x > -5.0f && poly[i].y-y < 5.0f && poly[i].y-y > -5.0f)
				indexDragged=i;
		}
	}
	else
		indexDragged=-1;
}

/* Evenement : souris bouge */
void mousemove(int x, int y)
{
	if(indexDragged!=-1)
	{
		poly[indexDragged].x=x;
		poly[indexDragged].y=y;
	}
	glutPostRedisplay();
}

/*************************************************************************/
/* Fonction principale */
/*************************************************************************/

int main(int argc, char *argv[]) 
{
	/* Initialisations globales */
	glutInit(&argc, argv);

	/* Définition des attributs de la fenetre OpenGL */
    glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE);

	/* Placement de la fenetre */
	glutInitWindowSize(width, height);
	glutInitWindowPosition(50, 50);
	
	/* Création de la fenetre */
    glutCreateWindow("Courbes");

	/* Choix de la fonction d'affichage */
	glutDisplayFunc(display);

	/* Choix de la fonction de redimensionnement de la fenetre */
	glutReshapeFunc(reshape);
	
	/* Choix des fonctions de gestion du clavier */
	glutKeyboardFunc(keyboard);
	//glutSpecialFunc(special);
	
	/* Choix de la fonction de gestion de la souris */
	glutMouseFunc(mouse);
	glutMotionFunc(mousemove);

	/* Boucle principale */
    glutMainLoop();

	/* Même si glutMainLoop ne rends JAMAIS la main, il faut définir le return, sinon
	le compilateur risque de crier */
    return 0;
}
