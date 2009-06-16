From: Petr Uzel <petr.uzel@suse.cz>
Subject: [multipath-tools] kpartx: DELETE logic question
Date: Tue, 16 Jun 2009 14:44:49 +0200
Message-ID: <20090616124449.GA12404@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi all,

In current multipath-tools, the deletion of devmappings is
done by following code snippet:

405  case DELETE:
406  for (j =3D n-1; j >=3D 0; j--) {
407    if (safe_sprintf(partname, "%s%s%d",
408             mapname, delim, j+1)) {
409       fprintf(stderr, "partname too small\n");
410       exit(1);
411    }
412    strip_slash(partname);
413 =20
414    if (!slices[j].size || !dm_map_present(partname))
415        continue;
416 =20
417    if (!dm_simplecmd(DM_DEVICE_REMOVE,
418                partname, 0)) {
419      r++;
420      continue;
421     }
422     if (verbose)
423     printf("del devmap : %s\n", partname);
424   }


I wonder what's the logic behind the test on line 414. The second part
(testing whether the mapping exists) is obvious. But what about the
first part? Why don't we want to delete mapping for partition with
size=3D=3D0, i.e. partition that no longer exists in the partition table?

Suppose following scenario:
- create 3 primary partitions on dm-0
- run kpartx -a /dev/dm-0
- delete partition #2
- run kpartx -d /dev/dm-0

The result is that mapping for partition #2 is not deleted - is this
what is expected?


Thanks,


--=20
Best regards / s pozdravem

Petr Uzel, Packages maintainer
---------------------------------------------------------------------
SUSE LINUX, s.r.o.                          e-mail: puzel@suse.cz
Lihovarsk=E1 1060/12                          http://www.suse.cz
190 00 Prague 9                            =20
Czech Republic                             =20
