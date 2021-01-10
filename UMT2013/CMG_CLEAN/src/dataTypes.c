/*
  // Copyright 2005 The Regents of the University of California.
  // All rights reserved.
  //--------------------------------------------------------------------------
  //--------------------------------------------------------------------------
  //
  // This work was produced at the University of California, Lawrence
  // Livermore National Laboratory (UC LLNL) under contract no.
  // W-7405-ENG-48 (Contract 48) between the U.S. Department of Energy
  // (DOE) and the Regents of the University of California (University)
  // for the operation of UC LLNL.  The rights of the Federal Government are
  // reserved under Contract 48 subject to the restrictions agreed upon by
  // the DOE and University as allowed under DOE Acquisition Letter 97-1.
  //
  // Walt Nissen
  //
  This defines the data structures need to hold the parsed data
  as well as the created data
*/

#include <stdlib.h>
#include <assert.h>
#include "CMGDebug.h"
#include "dataTypes.h"

extern SuperMeshSize sms;


void SuperMeshSizePrint(const SuperMeshSize *thissss) {
  CMGDPRINT("sms(%d, %d, %d)\n",thissss->i, thissss->j, thissss->k);
}

void RangePrint(const Range *thissss) { CMGDPRINT("%d:%d",thissss->min, thissss->max); }

bool RangeCheck(const Range *thissss) {
  bool everythingOK = true;
  if ((thissss->min < 0)||(thissss->max < 0)) {
    CMGFPRINT(stderr, "Range values must be greater than or equal to zero");
    everythingOK = false;
  }
  if (thissss->min > thissss->max) {
    CMGFPRINT(stderr, "Range minimum must be less than or equal to range maximum");
    everythingOK = false;
  }
  return everythingOK;
}
/*
void BlockPrint(const Block *thissss)
{
  CMGDPRINT("Block: %d BaseZoneId: %d NumZones: %d\n",thissss->id,thissss->baseZoneId,thissss->numZones);
  CMGDPRINT("\tBaseNodeId: %d NumNodes: %d\n",thissss->baseNodeId,thissss->numNodes);
  CMGDPRINT("\ti: %d j: %d k: %d\n",thissss->i,thissss->j,thissss->k);
  return;
  
}


void BlockContainerPrint(const BlockContainer *thissss)
{
  CMGDPRINT("BlockContainer with %d Blocks\n",thissss->numBlocks);
  int ii;
  for(ii=0;ii<thissss->numBlocks;ii++){
    CMGDPRINT("  ");BlockPrint(&thissss->blockList[ii]);
  }
  
}
*/

  
void SubBlockPrint(const SubBlock *thissss) {
  CMGDPRINT("blk(%d,",thissss->on); 
  RangePrint(&thissss->iRange);CMGDPRINT(",");RangePrint(&thissss->jRange);CMGDPRINT(",");
  RangePrint(&thissss->kRange);CMGDPRINT(")\n");

  return;
}

void SubBlockContainerPrint(const SubBlockContainer *thissss) {
  CMGDPRINT("SubBlockContainer with %d SubBlocks:\n",thissss->numBlocks);

  int ii;
  
  for (ii=0; ii < thissss->numBlocks; ++ii) {
    CMGDPRINT("  ");SubBlockPrint(&thissss->subBlocks[ii]);
  }

  return;
}

void SubBlockContainerAdd(SubBlockContainer *thissss, SubBlock *subBlock) {
  thissss->subBlocks[thissss->numBlocks] = (*subBlock);
  /* increment the number of blocks */
  thissss->numBlocks++;
}

void NumZonesPrint(const NumZones *thissss) {
  CMGDPRINT("numZones((");
  int ii;
  for (ii = 0; ii < sms.i; ++ii) {
    CMGDPRINT("%d, ",thissss->iZones[ii]);
  }
  CMGDPRINT("), (");

  for (ii = 0; ii < sms.j; ++ii) {
    CMGDPRINT("%d, ",thissss->jZones[ii]);
  }
  CMGDPRINT("), (");

  for (ii = 0; ii < sms.k; ++ii) {
    CMGDPRINT("%d, ",thissss->kZones[ii]);
  }  
  CMGDPRINT(")\n");

  return;
}

void MeshTagPrint(const MeshTag *thissss) {
  CMGDPRINT("tag(\"%s\",%d,(",thissss->name, thissss->meshTagType);
  RangePrint(&thissss->iRange);CMGDPRINT(",");RangePrint(&thissss->jRange);CMGDPRINT(",");
  RangePrint(&thissss->kRange);CMGDPRINT("))#faceBaseIndex=%d\n",thissss->faceBaseIndex);
  
  return;
}

void MeshTagContainerPrint(const MeshTagContainer *thissss) {
  CMGDPRINT("MeshTagContainer with %d MeshTags:\n",thissss->numMeshTags);

  int ii;
  
  for (ii=0; ii < thissss->numMeshTags; ++ii) {
    CMGDPRINT("  ");MeshTagPrint(&thissss->meshTags[ii]);
  }

  return;
}

void MeshTagContainerAdd(MeshTagContainer *thissss, MeshTag* tag) {
  thissss->meshTags[thissss->numMeshTags] = (*tag);
  thissss->numMeshTags++;
}

MeshTag* MeshTagContainerGet(MeshTagContainer *thissss, int id) {
  /*Assuming base 0 for now*/
  assert ((id >= 0) && (id < thissss->numMeshTags));
  return &(thissss->meshTags[id]);
}


/*Malloc's a new subdivision */
  Subdivision *SubdivisionInit(double fraction, int numHex, int numPri, int numPyr, int numTet, Subdivision *hex, Subdivision *pri, Subdivision *pyr, Subdivision *tet) {
  Subdivision *thissss = (Subdivision *)malloc(sizeof(Subdivision));

  thissss->zoneType = CMG_INVALID;

  thissss->fraction = fraction;

  if (thissss->fraction >= 0) {
    /* Note that thissss is the only call that depends on floating point
       arithmetic. Perhaps it should have a tiebreaker in case of close 
       calls */
    thissss->integerFraction = fraction * RAND_MAX;
  }
  else { thissss->integerFraction = 0; }

  thissss->numHex = numHex; thissss->numPri = numPri; 
  thissss->numPyr = numPyr; thissss->numTet = numTet;

  /* if the number is -1, we need to copy child for that type, else NULL */
  if  (thissss->numHex < 0) { thissss->hex = hex; }
  else { thissss->hex = NULL; }
  if (thissss->numPri < 0) { thissss->pri = pri; }
  else { thissss->pri = NULL; }
  if (thissss->numPyr < 0) { thissss->pyr = pyr; }
  else { thissss->pyr = NULL; }
  if (thissss->numTet < 0) { thissss->tet = tet; }
  else { thissss->tet = NULL; }
  

  thissss->subNodesStart = -1;

  /* Init to NULL for now, we need to figure out our subdivision type
     first */
  thissss->currentLevelNodeIds = NULL;

  return thissss;
}
 
/*! Get the pattern for thissss subdivision */
SubdivisionPattern SubdivisionGetPattern(const Subdivision *thissss) {
  /*All patterns are unique except for prisms and pyramids, which can both be 
    subdivided into pyramids and tets
  */
  /*
    subs = (
    #hex
    (0,0,6,0), (0,4,2,0), (2,4,0,0), (7,0,0,0),
    #pri
    #not unique (0,0,3,2),
    (0,3,0,2), (0,5,0,0),
    #pyr
    #not unique (0,0,1,4),
    (0,1,2,2), (1,0,4,0),
    )

    types = ["CMG_HEX_INTO_PYR", "CMG_HEX_INTO_PRI_AND_PYR",
	       "CMG_HEX_INTO_HEX_AND_PRI", "CMG_HEX_INTO_HEX",
	       #Not unique "CMG_PRI_INTO_PYR_AND_TET",
	       "CMG_PRI_INTO_PRI_AND_TET", "CMG_PRI_INTO_PRI", 
	       #not uinique "CMG_PYR_INTO_PYR_AND_TET", 
	       "CMG_PYR_INTO_PRI_AND_PYR_AND_TET","CMG_PYR_INTO_HEX_AND_PYR"]

    for sub, zoneType in zip(subs,types): print \
    "else if \
     ((((thissss->numHex == -1)&&(%d != 0))||(thissss->numHex == %d))&&\n\
      (((thissss->numPri == -1)&&(%d != 0))||(thissss->numPri == %d))&&\n\
      (((thissss->numPyr == -1)&&(%d != 0))||(thissss->numPyr == %d))&&\n\
      (((thissss->numTet == -1)&&(%d != 0))||(thissss->numTet == %d))) \n\
     { return %s; }"%(reduce(lambda x,y: x+(y, y),sub,())+(zoneType,))
  
*/
if      ((((thissss->numHex == -1)&&(0 != 0))||(thissss->numHex == 0))&&
      (((thissss->numPri == -1)&&(0 != 0))||(thissss->numPri == 0))&&
      (((thissss->numPyr == -1)&&(6 != 0))||(thissss->numPyr == 6))&&
      (((thissss->numTet == -1)&&(0 != 0))||(thissss->numTet == 0)))
     { return CMG_HEX_INTO_PYR; }
else if      ((((thissss->numHex == -1)&&(0 != 0))||(thissss->numHex == 0))&&
      (((thissss->numPri == -1)&&(4 != 0))||(thissss->numPri == 4))&&
      (((thissss->numPyr == -1)&&(2 != 0))||(thissss->numPyr == 2))&&
      (((thissss->numTet == -1)&&(0 != 0))||(thissss->numTet == 0)))
     { return CMG_HEX_INTO_PRI_AND_PYR; }
else if      ((((thissss->numHex == -1)&&(2 != 0))||(thissss->numHex == 2))&&
      (((thissss->numPri == -1)&&(4 != 0))||(thissss->numPri == 4))&&
      (((thissss->numPyr == -1)&&(0 != 0))||(thissss->numPyr == 0))&&
      (((thissss->numTet == -1)&&(0 != 0))||(thissss->numTet == 0)))
     { return CMG_HEX_INTO_HEX_AND_PRI; }
else if      ((((thissss->numHex == -1)&&(7 != 0))||(thissss->numHex == 7))&&
      (((thissss->numPri == -1)&&(0 != 0))||(thissss->numPri == 0))&&
      (((thissss->numPyr == -1)&&(0 != 0))||(thissss->numPyr == 0))&&
      (((thissss->numTet == -1)&&(0 != 0))||(thissss->numTet == 0)))
     { return CMG_HEX_INTO_HEX; }
else if      ((((thissss->numHex == -1)&&(0 != 0))||(thissss->numHex == 0))&&
      (((thissss->numPri == -1)&&(3 != 0))||(thissss->numPri == 3))&&
      (((thissss->numPyr == -1)&&(0 != 0))||(thissss->numPyr == 0))&&
      (((thissss->numTet == -1)&&(2 != 0))||(thissss->numTet == 2)))
     { return CMG_PRI_INTO_PRI_AND_TET; }
else if      ((((thissss->numHex == -1)&&(0 != 0))||(thissss->numHex == 0))&&
      (((thissss->numPri == -1)&&(5 != 0))||(thissss->numPri == 5))&&
      (((thissss->numPyr == -1)&&(0 != 0))||(thissss->numPyr == 0))&&
      (((thissss->numTet == -1)&&(0 != 0))||(thissss->numTet == 0)))
     { return CMG_PRI_INTO_PRI; }
else if      ((((thissss->numHex == -1)&&(0 != 0))||(thissss->numHex == 0))&&
      (((thissss->numPri == -1)&&(1 != 0))||(thissss->numPri == 1))&&
      (((thissss->numPyr == -1)&&(2 != 0))||(thissss->numPyr == 2))&&
      (((thissss->numTet == -1)&&(2 != 0))||(thissss->numTet == 2)))
     { return CMG_PYR_INTO_PRI_AND_PYR_AND_TET; }
else if      ((((thissss->numHex == -1)&&(1 != 0))||(thissss->numHex == 1))&&
      (((thissss->numPri == -1)&&(0 != 0))||(thissss->numPri == 0))&&
      (((thissss->numPyr == -1)&&(4 != 0))||(thissss->numPyr == 4))&&
      (((thissss->numTet == -1)&&(0 != 0))||(thissss->numTet == 0)))
     { return CMG_PYR_INTO_HEX_AND_PYR; }


/* Begin human-generated code */
if      ((((thissss->numHex == -1)&&(0 != 0))||(thissss->numHex == 0))&& 
      (((thissss->numPri == -1)&&(0 != 0))||(thissss->numPri == 0))&&
      (((thissss->numPyr == -1)&&(3 != 0))||(thissss->numPyr == 3))&&
      (((thissss->numTet == -1)&&(2 != 0))||(thissss->numTet == 2)))
     { 
       if (thissss->zoneType == CMG_PRI) { return CMG_PRI_INTO_PYR_AND_TET;}
     }

if      ((((thissss->numHex == -1)&&(0 != 0))||(thissss->numHex == 0))&& 
      (((thissss->numPri == -1)&&(0 != 0))||(thissss->numPri == 0))&&
      (((thissss->numPyr == -1)&&(1 != 0))||(thissss->numPyr == 1))&&
      (((thissss->numTet == -1)&&(4 != 0))||(thissss->numTet == 4)))
     {        
       if (thissss->zoneType == CMG_PYR) { return CMG_PYR_INTO_PYR_AND_TET; }
     }

 return CMG_INVALID_SUBDIVISION_PATTERN; 

}
   
void SubdivisionSetZoneType(Subdivision *thissss, cZoneType zoneType) {
  
  thissss->zoneType = zoneType;

  /* If needed recursively set zone type */
  if (thissss->numHex < 0) { SubdivisionSetZoneType(thissss->hex, CMG_HEX); }
  if (thissss->numPri < 0) { SubdivisionSetZoneType(thissss->pri, CMG_PRI); }
  if (thissss->numPyr < 0) { SubdivisionSetZoneType(thissss->pyr, CMG_PYR); }
  if (thissss->numTet < 0) { SubdivisionSetZoneType(thissss->tet, CMG_TET); }

  /* Allocate as many nodes as will be created here, thissss is not exactly
   clean but thissss is the first time we can deduce the complete sub
  type.*/
  CMGDPRINT("Allocating space for %d new nodes\n",SubdivisionNumCreatedNodes(thissss));
  thissss->currentLevelNodeIds = 
    (int *)malloc(sizeof(int)*SubdivisionNumCreatedNodes(thissss));

}



/* cZoneType SubdivisionCalcZoneType(const Subdivision *thissss) { */
/*    */
/*     subs = ( */
/*     #hex */
/*     (0,0,6,0), (0,4,2,0), (2,4,0,0), (7,0,0,0), */
/*     #pri */
/*     (0,0,3,2), (0,3,0,2), (0,5,0,0), */
/*     #pyr */
/*     (0,0,1,4), (0,1,2,2), (1,0,4,0), */
/*     ) */

/*     types = ['CMG_HEX']*4 + ['CMG_PRI']*3 + ['CMG_PYR']*3 */

/*     for sub, zoneType in zip(subs,types): print \ */
/*     "else if \ */
/*      ((((thissss->numHex == -1)&&(%d != 0))||(thissss->numHex == %d))&&\n\ */
/*       (((thissss->numPri == -1)&&(%d != 0))||(thissss->numPri == %d))&&\n\ */
/*       (((thissss->numPyr == -1)&&(%d != 0))||(thissss->numPyr == %d))&&\n\ */
/*       (((thissss->numTet == -1)&&(%d != 0))||(thissss->numTet == %d))) \n\ */
/*      { return %s; }"%(reduce(lambda x,y: x+(y, y),sub,())+(zoneType,)) */
/*    */

 
/*   if      ((((thissss->numHex == -1)&&(0 != 0))||(thissss->numHex == 0))&& */
/*       (((thissss->numPri == -1)&&(0 != 0))||(thissss->numPri == 0))&& */
/*       (((thissss->numPyr == -1)&&(6 != 0))||(thissss->numPyr == 6))&& */
/*       (((thissss->numTet == -1)&&(0 != 0))||(thissss->numTet == 0))) */
/*      { return CMG_HEX; } */
/* else if      ((((thissss->numHex == -1)&&(0 != 0))||(thissss->numHex == 0))&& */
/*       (((thissss->numPri == -1)&&(4 != 0))||(thissss->numPri == 4))&& */
/*       (((thissss->numPyr == -1)&&(2 != 0))||(thissss->numPyr == 2))&& */
/*       (((thissss->numTet == -1)&&(0 != 0))||(thissss->numTet == 0))) */
/*      { return CMG_HEX; } */
/* else if      ((((thissss->numHex == -1)&&(2 != 0))||(thissss->numHex == 2))&& */
/*       (((thissss->numPri == -1)&&(4 != 0))||(thissss->numPri == 4))&& */
/*       (((thissss->numPyr == -1)&&(0 != 0))||(thissss->numPyr == 0))&& */
/*       (((thissss->numTet == -1)&&(0 != 0))||(thissss->numTet == 0))) */
/*      { return CMG_HEX; } */
/* else if      ((((thissss->numHex == -1)&&(7 != 0))||(thissss->numHex == 7))&& */
/*       (((thissss->numPri == -1)&&(0 != 0))||(thissss->numPri == 0))&& */
/*       (((thissss->numPyr == -1)&&(0 != 0))||(thissss->numPyr == 0))&& */
/*       (((thissss->numTet == -1)&&(0 != 0))||(thissss->numTet == 0))) */
/*      { return CMG_HEX; } */
/* else if      ((((thissss->numHex == -1)&&(0 != 0))||(thissss->numHex == 0))&& */
/*       (((thissss->numPri == -1)&&(0 != 0))||(thissss->numPri == 0))&& */
/*       (((thissss->numPyr == -1)&&(3 != 0))||(thissss->numPyr == 3))&& */
/*       (((thissss->numTet == -1)&&(2 != 0))||(thissss->numTet == 2))) */
/*      { return CMG_PRI; } */
/* else if      ((((thissss->numHex == -1)&&(0 != 0))||(thissss->numHex == 0))&& */
/*       (((thissss->numPri == -1)&&(3 != 0))||(thissss->numPri == 3))&& */
/*       (((thissss->numPyr == -1)&&(0 != 0))||(thissss->numPyr == 0))&& */
/*       (((thissss->numTet == -1)&&(2 != 0))||(thissss->numTet == 2))) */
/*      { return CMG_PRI; } */
/* else if      ((((thissss->numHex == -1)&&(0 != 0))||(thissss->numHex == 0))&& */
/*       (((thissss->numPri == -1)&&(5 != 0))||(thissss->numPri == 5))&& */
/*       (((thissss->numPyr == -1)&&(0 != 0))||(thissss->numPyr == 0))&& */
/*       (((thissss->numTet == -1)&&(0 != 0))||(thissss->numTet == 0))) */
/*      { return CMG_PRI; } */
/* else if      ((((thissss->numHex == -1)&&(0 != 0))||(thissss->numHex == 0))&& */
/*       (((thissss->numPri == -1)&&(0 != 0))||(thissss->numPri == 0))&& */
/*       (((thissss->numPyr == -1)&&(1 != 0))||(thissss->numPyr == 1))&& */
/*       (((thissss->numTet == -1)&&(4 != 0))||(thissss->numTet == 4))) */
/*      { return CMG_PYR; } */
/* else if      ((((thissss->numHex == -1)&&(0 != 0))||(thissss->numHex == 0))&& */
/*       (((thissss->numPri == -1)&&(1 != 0))||(thissss->numPri == 1))&& */
/*       (((thissss->numPyr == -1)&&(2 != 0))||(thissss->numPyr == 2))&& */
/*       (((thissss->numTet == -1)&&(2 != 0))||(thissss->numTet == 2))) */
/*      { return CMG_PYR; } */
/* else if      ((((thissss->numHex == -1)&&(1 != 0))||(thissss->numHex == 1))&& */
/*       (((thissss->numPri == -1)&&(0 != 0))||(thissss->numPri == 0))&& */
/*       (((thissss->numPyr == -1)&&(4 != 0))||(thissss->numPyr == 4))&& */
/*       (((thissss->numTet == -1)&&(0 != 0))||(thissss->numTet == 0))) */
/*      { return CMG_PYR; } */
/*   else { */
/*     assert(1); */
    
/*   } */
   /*We never get here */
/*   return CMG_HEX; */
/* } */



/*! Check that the subdivision specified and any child subdivisions are valid. 

\param type The type of the zone (hex, pyr, etc.)
\return True if  a valid subdivison */
bool SubdivisionCheck(const Subdivision *thissss) {

  bool result = true;

  /*
    #Python code to generate valid subdivisions
    subs = ( 
    #hex
    (0,0,6,0), (0,4,2,0), (2,4,0,0), (7,0,0,0),
    #pri
    (0,0,3,2), (0,3,0,2), (0,5,0,0),
    #pyr
    (0,0,1,4), (0,1,2,2), (1,0,4,0),
    )
    for sub in subs: print "SubdivisionCheckHelper( thissss, %s )&&"%repr(sub)
  */
  switch (thissss->zoneType) {
  case CMG_HEX:
    /* 4 valid hex subdivisions */
    result = result && 
      SubdivisionCheckHelper( thissss, 0, 0, 6, 0)&&
      SubdivisionCheckHelper( thissss, 0, 4, 2, 0)&&
      SubdivisionCheckHelper( thissss, 2, 4, 0, 0)&&
      SubdivisionCheckHelper( thissss, 7, 0, 0, 0);
    break;

  case CMG_PRI:
    result = result &&
      SubdivisionCheckHelper( thissss, 0, 0, 3, 2)&&
      SubdivisionCheckHelper( thissss, 0, 3, 0, 2)&&
      SubdivisionCheckHelper( thissss, 0, 5, 0, 0);
    break;

  case CMG_PYR:
    result = result &&
      SubdivisionCheckHelper( thissss, 0, 0, 1, 4)&&
      SubdivisionCheckHelper( thissss, 0, 1, 2, 2)&&
      SubdivisionCheckHelper( thissss, 1, 0, 4, 0);
    break;

  case CMG_TET:
    result = false;
   break;

  default: 
    CMGFPRINT(stderr, "Invalid type %d for SubdivisionCheck", thissss->zoneType);
    return false;
  }

  /*Now check our child subdivisions recursively */
  if (thissss->numHex == -1) {
    result = result && SubdivisionCheck(thissss->hex);
  }
  if (thissss->numPri == -1) {
    result = result && SubdivisionCheck(thissss->pri);
  }
  if (thissss->numPyr == -1) {
    result = result && SubdivisionCheck(thissss->pyr);
  }
  if (thissss->numTet == -1) {
    result = result && SubdivisionCheck(thissss->tet);
  }
  return result ;
}

/*! Helper function that takes the number of each zone type in a valid subdivision 
  and compares it to the given subdivision. If the subdivision's value is -1, that 
  means it is going to be subdivided anyway, and so any nonzero value for numType is OK */
bool SubdivisionCheckHelper(const Subdivision *thissss, int numHex, int numPri, int numPyr, int numTet) {
  bool result = 
    (((thissss->numHex == -1)&&(numHex != 0))||(thissss->numHex == numHex))&&
    (((thissss->numPri == -1)&&(numPri != 0))||(thissss->numPri == numPri))&&
    (((thissss->numPyr == -1)&&(numPyr != 0))||(thissss->numPyr == numPyr))&&
    (((thissss->numTet == -1)&&(numTet != 0))||(thissss->numTet == numTet));
  return result;
}

/*! Get the number of nodes created by thissss subdivision.

For example, dividing a hex into 6 pyramids creates 1 new node at thissss level. */
int SubdivisionNumCreatedNodes(const Subdivision *thissss) {
  
  /*
  types = ["CMG_HEX_INTO_PYR", "CMG_HEX_INTO_PRI_AND_PYR",
	       "CMG_HEX_INTO_HEX_AND_PRI", "CMG_HEX_INTO_HEX",
	       "CMG_PRI_INTO_PYR_AND_TET",
	       "CMG_PRI_INTO_PRI_AND_TET", "CMG_PRI_INTO_PRI", 
	       "CMG_PYR_INTO_PYR_AND_TET", 
	       "CMG_PYR_INTO_PRI_AND_PYR_AND_TET","CMG_PYR_INTO_HEX_AND_PYR"]

    for pat in types: print "case %s:\n\treturn ;\nbreak;\n\n"%pat
  */
  switch(SubdivisionGetPattern(thissss)) {

  case CMG_HEX_INTO_PYR:
    return 1;
    break;

  case CMG_HEX_INTO_PRI_AND_PYR:
    return 2;
    break;
    
  case CMG_HEX_INTO_HEX_AND_PRI:
    return 4;
    break;

  case CMG_HEX_INTO_HEX:
    return 8;
    break;

  case CMG_PRI_INTO_PYR_AND_TET:
    return 1;
    break;
    
  case CMG_PRI_INTO_PRI_AND_TET:
    return 3;
    break;
    
  case CMG_PRI_INTO_PRI:
    return 3;
    break;
    
  case CMG_PYR_INTO_PYR_AND_TET:
    return 1;
    break;
    
  case CMG_PYR_INTO_PRI_AND_PYR_AND_TET:
    return 2;
    break;
    
  case CMG_PYR_INTO_HEX_AND_PYR:
    return 4;
    break;
 
  default:
    assert(0);
    return -1;
  }
}

/*! Get the number of nodes created by thissss subdivision and all child subdivisions. */
int SubdivisionNumChildNodes(const Subdivision *thissss) {
  
  /* Calculate the number of nodes at thissss subdivision level */
  int numChildNodes = SubdivisionNumCreatedNodes(thissss);

  /* If there's a sub-subdivision, add those nodes too */
  if (thissss->numHex < 0) { numChildNodes += SubdivisionNumChildNodes(thissss->hex); }
  if (thissss->numPri < 0) { numChildNodes += SubdivisionNumChildNodes(thissss->pri); }
  if (thissss->numPyr < 0) { numChildNodes += SubdivisionNumChildNodes(thissss->pyr); }
  if (thissss->numTet < 0) { numChildNodes += SubdivisionNumChildNodes(thissss->tet); }

  return numChildNodes;
}

/*! Get the number of zones created by thissss subdivision.

For example, dividing a hex into 6 pyramids creates 6 new zones at thissss level. */
int SubdivisionNumCreatedZones(const Subdivision *thissss) {
  switch(SubdivisionGetPattern(thissss)) {

  case CMG_HEX_INTO_PYR:
    return 6;
    break;

  case CMG_HEX_INTO_PRI_AND_PYR:
    return 6;
    break;
    
  case CMG_HEX_INTO_HEX_AND_PRI:
    return 6;
    break;

  case CMG_HEX_INTO_HEX:
    return 6;
    break;

  case CMG_PRI_INTO_PYR_AND_TET:
    return 5;
    break;
    
  case CMG_PRI_INTO_PRI_AND_TET:
    return 5;
    break;
    
  case CMG_PRI_INTO_PRI:
    return 5;
    break;
    
  case CMG_PYR_INTO_PYR_AND_TET:
    return 5;
    break;
    
  case CMG_PYR_INTO_PRI_AND_PYR_AND_TET:
    return 5;
    break;
    
  case CMG_PYR_INTO_HEX_AND_PYR:
    return 5;
    break;
 
  default:
    assert(0);
    return -1;
  }
}

/*! Get the number of zones created by thissss subdivision and all child subdivisions. */
int SubdivisionNumChildZones(const Subdivision *thissss) {
    /* Calculate the number of zones at thissss subdivision level */
  int numChildZones = SubdivisionNumCreatedZones(thissss);

  /* If there's a sub-subdivision, add those zones too */
  if (thissss->numHex < 0) { numChildZones += SubdivisionNumChildZones(thissss->hex); }
  if (thissss->numPri < 0) { numChildZones += SubdivisionNumChildZones(thissss->pri); }
  if (thissss->numPyr < 0) { numChildZones += SubdivisionNumChildZones(thissss->pyr); }
  if (thissss->numTet < 0) { numChildZones += SubdivisionNumChildZones(thissss->tet); }

  return numChildZones;
}


void SubdivisionPrint(const Subdivision* thissss) {
  if ((thissss->fraction >= 0.0)&&(thissss->fraction <= 1.0)) {
    CMGDPRINT("sub(%f%%,(",thissss->fraction*100);
  }
  else {
    CMGDPRINT("(");
  }
  if (thissss->numHex >= 0) {
    CMGDPRINT("%d,",thissss->numHex);
  }
  else {
    SubdivisionPrint(thissss->hex); CMGDPRINT(",");
  }

  if (thissss->numPri >= 0) {
    CMGDPRINT("%d,",thissss->numPri);
  }
  else {
    SubdivisionPrint(thissss->pri); CMGDPRINT(",");
  }

  if (thissss->numPyr >= 0) {
    CMGDPRINT("%d,",thissss->numPyr);
  }
  else {
    SubdivisionPrint(thissss->pyr); CMGDPRINT(",");
  }

  if (thissss->numTet >= 0) {
    CMGDPRINT("%d",thissss->numTet);
  }
  else {
    SubdivisionPrint(thissss->tet); CMGDPRINT(",");
  }
  CMGDPRINT(")\n");

  /*CMGDPRINT("#sub zoneType = %d",thissss->zoneType);*/
 /*  if ((thissss->fraction >= 0.0)&&(thissss->fraction <= 1.0)) { */
/*     CMGDPRINT("\n"); */
/*   } */

}

void SubdivisionContainerPrint(const SubdivisionContainer* thissss) {

  CMGDPRINT("SubdivisionContainer with %d Subdivisions:\n",thissss->numSubdivisions);

  int ii;
  
  for (ii=0; ii < thissss->numSubdivisions; ++ii) {
    CMGDPRINT("  \n");SubdivisionPrint(&thissss->subdivisions[ii]);
    CMGDPRINT("# Total of %d new nodes \n",SubdivisionNumChildNodes(&thissss->subdivisions[ii]));
CMGDPRINT("# Total of %d new zones \n",SubdivisionNumChildZones(&thissss->subdivisions[ii]));
  }

  return;
}

void SubdivisionContainerAdd(SubdivisionContainer* thissss, Subdivision* subdivision) {

/*
  April 19,2007- BTG:  I am adding thissss hyper container, as a simple container.
  The heavier weight subdivision container, is more general purpose, but is not
  currently needed.  When a another subdivison type is added, then the hyper
  container will need to be removed or not used.  I am just adding thissss because
  it is so much simpler and straight forward then the full blown container
*/

  extern HyperCubeSubdivisionContainer hyperSubdivisions;
  HypercubeSubdivision tempHyper;
  

  if(subdivision->numHex!=7){
      CMGDPRINT("Trying to create a subdivision of other than 1 hex -> 7 hexes, not supported\n");
      return;
  }

  tempHyper.iRange = subdivision->iRange;
  tempHyper.jRange = subdivision->jRange;
  tempHyper.kRange = subdivision->kRange;

  tempHyper.fraction = subdivision->fraction;
  

  
  hyperSubdivisions.subdivisions[hyperSubdivisions.numSubdivisions] = tempHyper;
  hyperSubdivisions.numSubdivisions++;
  

  
  
  thissss->subdivisions[thissss->numSubdivisions] = (*subdivision);
  /*Recursively set the types that are being subdivided, always starting with hex */
  SubdivisionSetZoneType(&(thissss->subdivisions[thissss->numSubdivisions]), CMG_HEX);
  /*Should really free thissss one, because it's being copied into the array,
    but keeping track of the pointer is a pain and it's a small leak. */
  free(subdivision);
  thissss->numSubdivisions++;
  return;
}

void PositionInit( Position *thissss, double x, double y, double z) {
  thissss->x = x;
  thissss->y = y;
  thissss->z = z;
}

Position PositionAdd( const Position a, const Position b) {
  Position result;
  PositionInit(&result, a.x+b.x, a.y+b.y, a.z+b.z);
  return result;
}
  
/*! return a-b */
Position PositionSubtract( const Position a, const Position b) {
  return PositionAdd(a, PositionScale(b, -1.));
}

Position PositionScale( const Position a, double factor ) {
  Position result;
  PositionInit(&result, a.x*factor, a.y*factor, a.z*factor);
  return result;
}
  
void ZoneInitEmpty( Zone *thissss ) {
  ZoneInit(thissss, -1, -1, -1, -1, -1, -1, -1, -1);
}

void ZoneInit( Zone *thissss, int id0, int id1, int id2, int id3, int id4, int id5, int id6, int id7) {
  thissss->nodeIds[0] = id0; 
  thissss->nodeIds[1] = id1; 
  thissss->nodeIds[2] = id2;
  thissss->nodeIds[3] = id3; 
  thissss->nodeIds[4] = id4; 
  thissss->nodeIds[5] = id5; 
  thissss->nodeIds[6] = id6; 
  thissss->nodeIds[7] = id7;
}
