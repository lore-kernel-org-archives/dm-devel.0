From: Dwaine_Garden@wsib.on.ca
Subject: [PATCH] dm-striped device sizes must be multiple of
	chunk-size(Causes Failures)
Date: Mon, 1 May 2006 17:05:57 -0400
Message-ID: <OFFE1FB53B.25095B7A-ON85257161.0072CF32-85257161.0073E75D@wsib.on.ca>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: dwainegarden@rogers.com
List-Id: dm-devel.ids


It looks like dmsetup need to be patched as well.   There is a bug opened
up for dmraid because after this
patch, Fedora 5 installs would not boot with kernel 2.6.16.  There is a
patch to round down the stripe size to be multiple of the chunk-size, but
the computers still fail trying to boot and mount volumes.

After Heinz patched dmraid, it now fixed.  It looks like dmsetup needs to
be patched as well(Or something within device-mapper).  Via_ecfdfiehfa is
not a multiple of chunk-size,   Both dmraid and dmsetup should match.   So
all software raid0 setup with dmraid still fail to boot under 2.6.16+.
Nvidia, Intel and Via chipsets are confirmed impacted, but all the chipsets
which has this software raid0 will have this problem.

                                                                            
 dmraid -s                                                                  
 (Size Looks                                                                
 Good)(New                                                                  
 patched dmraid                                                             
 rc11-pre1-test                                                             
 )                                                                          
 *** Active Set                                                             
 name   :                                                                   
 via_ecfdfiehfa                                                             
 size   :                                                                   
 312499968                                                                  
 stride : 128                                                               
 type   :                                                                   
 stripe                                                                     
 status : ok                                                                
 subsets: 0                                                                 
 devs   : 2                                                                 
 spares : 0                                                                 
                                                                            
 dmsetup -table                                                             
 (Size is bad)                                                              
 via_ecfdfiehfa                                                             
 2: 0 312287535                                                             
 linear 253:0                                                               
 208845                                                                     
 via_ecfdfiehfa                                                             
 1: 0 208782                                                                
 linear 253:0                                                               
 63                                                                         
 via_ecfdfiehfa                                                             
 : 0 312499998                                                              
 striped 2 128                                                              
 8:0 0 8:16 0                                                               
 VolGroup00-Log                                                             
 Vol01: 0                                                                   
 4063232 linear                                                             
 253:2                                                                      
 308150656                                                                  
 VolGroup00-Log                                                             
 Vol00: 0                                                                   
 308150272                                                                  
 linear 253:2                                                               
 384                                                                        
                                                                            
 Here is the                                                                
 Fedora Bug                                                                 
 report for                                                                 
 interested                                                                 
 people.   A                                                                
 lot of testing                                                             
 has been                                                                   
 completed.                                                                 
                                                                            
 https://bugzil                                                             
 la.redhat.com/                                                             
 bugzilla/show_                                                             
 bug.cgi?id=186                                                             
 842                                                                        
                                                                            
                                                                            



Dwaine


The dm-striped target currently does not enforce that the size of a stripe
device be a multiple of the chunk-size. Under certain conditions, this can
lead to I/O requests going off the end of an underlying device. This
test-case shows one example.

echo "0 100 linear /dev/hdb1 0" | dmsetup create linear0
echo "0 100 linear /dev/hdb1 100" | dmsetup create linear1
echo "0 200 striped 2 32 /dev/mapper/linear0 0 /dev/mapper/linear1 0" | \
   dmsetup create stripe0
dd if=/dev/zero of=/dev/mapper/stripe0 bs=1k

This will produce the output:
dd: writing '/dev/mapper/stripe0': Input/output error
97+0 records in
96+0 records out

And in the kernel log will be:
attempt to access beyond end of device
dm-0: rw=0, want=104, limit=100

The patch below will check that the table size is a multiple of the stripe
chunk-size when the table is created, which will prevent the above striped
device from being created.

This should not effect tools like LVM or EVMS, since in all the cases I can

think of, striped devices are always created with the sizes being a
multiple
of the chunk-size.

--
Kevin Corry
kevcorry us ibm com
http://www.ibm.com/linux/
http://evms.sourceforge.net/


The size of a stripe device must be a multiple of its chunk-size.

Signed-off-by: Kevin Corry <kevcorry us ibm com>

 dm-stripe.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- diff/drivers/md/dm-stripe.c            2006-03-14 15:57:30.000000000
-0600
+++ source/drivers/md/dm-stripe.c          2006-03-14 16:01:41.000000000
-0600
@@ -103,6 +103,12 @@
                         return -EINVAL;
             }

+            if (((uint32_t)ti->len) & (chunk_size - 1)) {
+                        ti->error = "dm-stripe: Target length not
divisable by "
+                            "chunk size";
+                        return -EINVAL;
+            }
+
             width = ti->len;
             if (sector_div(width, stripes)) {
                         ti->error = "dm-stripe: Target length not
divisable by "



*********************************************************************
The information in this e-mail is intended solely for the addressee(s) 
named, and is confidential. Any other distribution, disclosure or 
copying is strictly prohibited. If you have received this communication
in error, please reply by e-mail to the sender and delete or destroy all
copies of this message.

Les renseignements contenus dans le pr'esent message 'electronique sont 
confidentiels et concernent exclusivement le(s) destinataire(s)
'esign'e(s). Il est strictement interdit de distribuer ou de copier ce 
message.  Si vous avez recu ce message par erreur, veuillez r'epondre 
par courriel `a l'exp'editeur et effacer ou d'etruire toutes les copies du
pr'esent message..
