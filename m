From: "Caushik, Ramesh" <ramesh.caushik@intel.com>
Subject: Some issues noticed in my testing.
Date: Mon, 7 Feb 2005 15:18:17 -0800
Message-ID: <EA4DC661A6353747A2E5C0DE8792DDDE07B82237@orsmsx404.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

Hi Christophe,
I noticed a failure in multipath-tools-0.4.2 when executing the
following scenario.

i) Run multipathd & multipath with 1 of 2 paths in the system available.
ii)activate the other path.
iii) run multipath again.

Expect the newly inserted path to be incorporated into the original path
groups. Does not happen. Traced it to a problem in the pgcmp2 function.
Patch below should fix it. Also in step iii) above running multipath
with a parameter (conf->dev) will not include the additional path into
the particular mp because the select_alias function not called in the
coalesce_paths function so the strncmp(mpp->alias,conf->dev,....) in
main will always fail. Patch below should fix it.=20

Also while testing with a modified scsi_debug driver (to expose multiple
paths to the same device) noticed that sysfs vendor name for the
scsi_debug device is "Linux   " which fails to match with a "Linux"
vendor name in the conf name and so device specific settings are not
picked up. Think it is a good idea to chomp off trailing whitespace from
vendor and product names. See patches below.  Regards,

Ramesh.

"Views expressed are mine, and not those of Intel Corporation"=20


diff -r /home/rcaushik/multipath-tools-0.4.2/libmultipath/hwtable.c
multipath-tools-0.4.2/libmultipath/hwtable.c
11a12,13
> int  strcmp_chomp(char *str1, char *str2);
>=20
20c22
< 		    strcmp(hwe->vendor, vendor) =3D=3D 0 &&
---
> 		    strcmp_chomp(hwe->vendor, vendor) =3D=3D 0 &&
22c24
< 			strcmp(hwe->product, product) =3D=3D 0))
---
> 			strcmp_chomp(hwe->product, product) =3D=3D 0))
58a61,64
> int  strcmp_chomp(char *str1, char *str2)
> {
> 	int i;
> 	char s1[PARAMS_SIZE],s2[PARAMS_SIZE];
59a66,76
>         if(!str1 || !str2)
> 		return 1;
> 	strncpy(s1,str1,PARAMS_SIZE);
> 	strncpy(s2,str2,PARAMS_SIZE);
> 	=09
> 	for(i=3Dstrlen(s1)-1;i >=3D0 && isspace(s1[i]); --i) ;
> 	s1[++i]=3D'\0';
> 	for(i=3Dstrlen(s2)-1;i >=3D0 && isspace(s2[i]); --i) ;
> 	s2[++i]=3D'\0';
> 	return(strcmp(s1,s2));
> }
diff -r /home/rcaushik/multipath-tools-0.4.2/multipath/main.c
multipath-tools-0.4.2/multipath/main.c
405c405
<=20
---
> 		select_alias(mpp);
672c672
< 				break;
---
> 				/* break; */
       =20

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
