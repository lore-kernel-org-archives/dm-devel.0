From: =?gb2312?q?=CB=B8=20=C2=C0?= <lv_shuo@yahoo.com.cn>
Subject: virtual device driver for help
Date: Wed, 14 Nov 2007 10:30:33 +0800 (CST)
Message-ID: <217696.85027.qm@web15004.mail.cnb.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0323595544=="
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
List-Id: dm-devel.ids

--===============0323595544==
Content-Type: multipart/alternative; boundary="0-490143424-1195007433=:85027"
Content-Transfer-Encoding: 7bit

--0-490143424-1195007433=:85027
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable

I am implementing a virtual device driver for learning purpose,now i find=
 it's performance is bad,i cann't get reason for it. I read the raid0 sou=
rce code,you are the author,please you help me.
  =20
  disk read /dev/vbd(virtual) =20
  [root@server_1 vbd_test_7]# dd if=3D/dev/vbd0 of=3D/dev/zero count=3D10=
00000 bs=3D1k
1000000+0 records in
1000000+0 records out
1024000000 bytes (1.0 GB) copied, 15.8438 seconds, 64.6 MB/s
  =20
  [root@server_1 vbd_test_7]# dd if=3D/dev/sdb of=3D/dev/zero count=3D100=
0000 bs=3D1k
1000000+0 records in
1000000+0 records out
1024000000 bytes (1.0 GB) copied, 6.18553 seconds, 166 MB/s
  =20
  what make the performance difference?=20
  =20
  =20
  code:
  =20
  MODULE_LICENSE("Dual BSD/GPL");
  static int vbd_major =3D 0;
module_param(vbd_major, int, 0);
static int hardsect_size =3D 512;
module_param(hardsect_size, int, 0);
static int nsectors =3D 1024*1024*2; /* How big the drive is */
module_param(nsectors, int, 0);
  #define WINDOWS_ROBOT_NUM  4
#define SNOPSHOT_EACH_WINDOWS_ROBOT 4

static int ndevices =3D 1;
module_param(ndevices, int, 0);
  /*
 * We can tweak our hardware sector size, but the kernel talks to us
 * in terms of small sectors, always.
 */
#define KERNEL_SECTOR_SIZE 512
#define VBD_MINORS           1
  /*
 * The internal representation of our device.
 */
struct vbd_dev=20
{
    short users;                    /* How many users */
    short media_change;             /* Flag a media change? */
    spinlock_t lock;                /* For mutual exclusion */
    struct request_queue *queue;    /* The device request queue */
    struct gendisk *gd;             /* The gendisk structure */
};
  typedef struct vbd_dev vbd_dev_t ;
static vbd_dev_t *Devices =3D NULL;
  static struct block_device *bdev =3D NULL;
 =20
static int vbd_endio(struct bio* bio,unsigned int done,int error)
{
 struct bio*  ori_bio;
 ori_bio =3D bio->bi_private;
   //printk(KERN_INFO"clone_endio:%d\n",ori_bio->bi_size);
 bio_endio(ori_bio,ori_bio->bi_size,error);
 //printk(KERN_INFO"clone_endio\n");
  bio_put(bio);
   return 0;
}
 =20
static int vbd_make_request(request_queue_t *q, struct bio *bio)
{
 //struct bio_vec *bvec;
 struct bio* newbio;
=20
=20
 //sector_t sector =3D bio->bi_sector;
 //sector_t total_sector_num =3D 0;
 //int i;
  #if 0
 printk("********************start*************************\n");
 if(bio->bi_sector%8!=3D0)printk("**************what we need happen******=
***\n");
 printk("bio->bi_sector=3D%d\n",bio->bi_sector);
 printk("bio->bi_vcnt=3D%d\n",bio->bi_vcnt);
 printk("bio->bi_idx=3D%d\n",bio->bi_idx);
 printk("bio->bi_max_vecs=3D%d\n",bio->bi_max_vecs);
 printk("bio->bi_size=3D%d secotrs\n",(bio->bi_size)>>9);=20
 for(i=3D0;i<bio->bi_vcnt;i++)
 {
  total_sector_num+=3D(bio->bi_io_vec[i].bv_len)>>9;
  printk("total sector num =3D%d\n",total_sector_num);
 }
 printk("********************finish*************************\n");
#endif=20
 =20
 newbio =3D bio_clone(bio,GFP_NOIO);=20
 newbio->bi_bdev =3D bdev;
 newbio->bi_end_io =3D vbd_endio;
 newbio->bi_private =3D bio;=20
   newbio->bi_flags &=3D ~(1 << BIO_SEG_VALID);
 printk(KERN_INFO"newbio->bi_flags=3D%d\n",newbio->bi_flags);
 printk(KERN_INFO"bio->bi_flags=3D%d\n",bio->bi_flags);=20
 generic_make_request(newbio);=20
   return 0;
}
 =20
/*
 * Open and close.
 */
  static int vbd_open(struct inode *inode, struct file *filp)
{
   // static int i=3D10;
 vbd_dev_t *vbd_dev =3D inode->i_bdev->bd_disk->private_data;
 dev_t  testdev;
   filp_open("/dev/sdb",O_RDWR,0);
 =20
 printk("********************start*************************\n");
 testdev =3D MKDEV(8,16);
 bdev =3D bdget(testdev);
 if(bdev=3D=3DNULL)
 {
  printk(KERN_INFO"notice:null device**********\n");
  return 0;
 }
 =20
 filp->private_data =3D vbd_dev;
 spin_lock(&vbd_dev->lock);
 if (! vbd_dev->users)=20
 {
  check_disk_change(inode->i_bdev);
 }
 vbd_dev->users++;
 spin_unlock(&vbd_dev->lock);
 return 0;
}
 =20
static int vbd_release(struct inode *inode, struct file *filp)
{
 struct vbd_dev *dev =3D inode->i_bdev->bd_disk->private_data;
   spin_lock(&dev->lock);
 dev->users--;
 spin_unlock(&dev->lock);
   return 0;
}
  /*
 * Look for a (simulated) media change.
 */
int vbd_media_changed(struct gendisk *gd)
{
 struct vbd_dev *dev =3D gd->private_data;
=20
 return dev->media_change;
}
  /*
 * Revalidate.  WE DO NOT TAKE THE LOCK HERE, for fear of deadlocking
 * with open.  That needs to be reevaluated.
 */
int vbd_revalidate(struct gendisk *gd)
{
 struct vbd_dev *dev =3D gd->private_data;
=20
 if (dev->media_change)=20
 {
  dev->media_change =3D 0; =20
 }
 return 0;
}
  =20
  /*
 * The ioctl() implementation
 */
  int vbd_ioctl (struct inode *inode, struct file *filp,
                 unsigned int cmd, unsigned long arg)
{
   struct hd_geometry geo;
 //struct vbd_dev *dev =3D filp->private_data;
    //static int i=3D0;
=20
 switch(cmd) {
     case HDIO_GETGEO:
         /*
   * Get geometry: since we are a virtual device, we have to make
   * up something plausible.  So we claim 16 sectors, four heads,
   * and calculate the corresponding number of cylinders.  We set the
   * start of data at sector four.
   */
    geo.heads =3D 4;
  geo.sectors =3D 16;
  geo.start =3D 4;
  if (copy_to_user((void __user *) arg, &geo, sizeof(geo)))
   return -EFAULT;
  return 0;
 }
 printk(KERN_INFO"ioctl:%d\n",cmd);
=20
 return -ENOTTY; /* unknown command */
}
  =20
  /*
 * The device operations structure.
 */
static struct block_device_operations vbd_ops =3D {
 .owner           =3D THIS_MODULE,
 .open           =3D vbd_open,
 .release   =3D vbd_release,
 .media_changed   =3D vbd_media_changed,
 .revalidate_disk =3D vbd_revalidate,
 .ioctl          =3D vbd_ioctl
};
 =20
/*
 * Set up our internal device.
 */
static void setup_device(struct vbd_dev *dev, int which)
{
 /*
  * Get some memory.
  */
 memset (dev, 0, sizeof (struct vbd_dev));
 spin_lock_init(&dev->lock);
   dev->queue =3D blk_alloc_queue(GFP_KERNEL);
 if (dev->queue =3D=3D NULL)
  return;
   /**/
 blk_queue_make_request(dev->queue, vbd_make_request);
 =20
 blk_queue_hardsect_size(dev->queue, hardsect_size);
 dev->queue->queuedata =3D dev;
   /*
  * And the gendisk structure.we just want 1 minor here
  */
 dev->gd =3D alloc_disk(VBD_MINORS);
 if (! dev->gd)=20
 {
  printk (KERN_NOTICE "alloc_disk failure\n");
  return;
 }
   /*
  * Set some other parameters
  */
 dev->gd->major =3D vbd_major;
 dev->gd->first_minor =3D which*VBD_MINORS;
 dev->gd->fops =3D &vbd_ops;
 dev->gd->queue =3D dev->queue;
 dev->gd->private_data =3D dev;
 snprintf (dev->gd->disk_name, 32, "vbd%d", which );
 set_capacity(dev->gd, nsectors*(hardsect_size/KERNEL_SECTOR_SIZE));
 add_disk(dev->gd);
 return;
=20
}
  =20
  static int __init vbd_init(void)
{
 int i;
 /*
  * Get registered.
  */
 vbd_major =3D register_blkdev(vbd_major, "vbd");
 if (vbd_major <=3D 0) {
  printk(KERN_WARNING "vbd: unable to get major number\n");
  return -EBUSY;
 }
 /*
  * Allocate the device array, and initialize each one.
  */
 Devices =3D kmalloc(ndevices*sizeof (struct vbd_dev), GFP_KERNEL);
 if (Devices =3D=3D NULL)
 {
  goto out_unregister;
 }
 for (i =3D 0; i < ndevices; i++)=20
 {
  setup_device(Devices + i, i);
 }
   =20
 return 0;
    out_unregister:
 unregister_blkdev(vbd_major, "vbd");
 return -ENOMEM;
}
  static void vbd_exit(void)
{
 int i;
   for (i =3D 0; i < ndevices; i++)=20
 {
  struct vbd_dev *dev =3D Devices + i;
  if (dev->gd)=20
  {
   del_gendisk(dev->gd);
   put_disk(dev->gd);
  }
  if (dev->queue)=20
  {
   blk_cleanup_queue(dev->queue);
  }  =20
 }
 unregister_blkdev(vbd_major, "vbd");
 kfree(Devices);
}
=20
module_init(vbd_init);
module_exit(vbd_exit

      =20
---------------------------------
 @yahoo.cn =D0=C2=D3=F2=C3=FB=A1=A2=CE=DE=CF=DE=C1=BF=A3=AC=BF=EC=C0=B4=C7=
=C0=D7=A2=A3=A1
--0-490143424-1195007433=:85027
Content-Type: text/html; charset=gb2312
Content-Transfer-Encoding: quoted-printable

<DIV>I am implementing a virtual device driver for learning purpose,now i=
 find it's performance is bad,i cann't get reason for it. I read the raid=
0 source code,you are the author,please you help me.</DIV>  <DIV>&nbsp;</=
DIV>  <DIV>disk read /dev/vbd(virtual)&nbsp; </DIV>  <DIV>[root@server_1 =
vbd_test_7]# dd if=3D/dev/vbd0 of=3D/dev/zero count=3D1000000 bs=3D1k<BR>=
1000000+0 records in<BR>1000000+0 records out<BR>1024000000 bytes (1.0 GB=
) copied, 15.8438 seconds, 64.6 MB/s</DIV>  <DIV>&nbsp;</DIV>  <DIV>[root=
@server_1 vbd_test_7]# dd if=3D/dev/sdb of=3D/dev/zero count=3D1000000 bs=
=3D1k<BR>1000000+0 records in<BR>1000000+0 records out<BR>1024000000 byte=
s (1.0 GB) copied, 6.18553 seconds, 166 MB/s</DIV>  <DIV>&nbsp;</DIV>  <D=
IV>what make the performance difference? </DIV>  <DIV>&nbsp;</DIV>  <DIV>=
&nbsp;</DIV>  <DIV>code:</DIV>  <DIV>&nbsp;</DIV>  <DIV>MODULE_LICENSE("D=
ual BSD/GPL");</DIV>  <DIV>static int vbd_major =3D 0;<BR>module_param(vb=
d_major, int, 0);<BR>static int hardsect_size =3D
 512;<BR>module_param(hardsect_size, int, 0);<BR>static int nsectors =3D =
1024*1024*2;&nbsp;/* How big the drive is */<BR>module_param(nsectors, in=
t, 0);</DIV>  <DIV>#define WINDOWS_ROBOT_NUM&nbsp; 4<BR>#define SNOPSHOT_=
EACH_WINDOWS_ROBOT 4<BR><BR>static int ndevices =3D 1;<BR>module_param(nd=
evices, int, 0);</DIV>  <DIV>/*<BR>&nbsp;* We can tweak our hardware sect=
or size, but the kernel talks to us<BR>&nbsp;* in terms of small sectors,=
 always.<BR>&nbsp;*/<BR>#define KERNEL_SECTOR_SIZE&nbsp;512<BR>#define VB=
D_MINORS &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1</DIV>  =
<DIV>/*<BR>&nbsp;* The internal representation of our device.<BR>&nbsp;*/=
<BR>struct vbd_dev <BR>{<BR>&nbsp;&nbsp;&nbsp; short users;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; /* How many users */<BR>&nbsp;&nbsp;&nbsp; sh=
ort media_change;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp; /* Flag a media change?
 */<BR>&nbsp;&nbsp;&nbsp; spinlock_t lock;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* For mutual=
 exclusion */<BR>&nbsp;&nbsp;&nbsp; struct request_queue *queue;&nbsp;&nb=
sp;&nbsp; /* The device request queue */<BR>&nbsp;&nbsp;&nbsp; struct gen=
disk *gd;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; /* The gendisk structure */<BR>};</DIV>  <DIV>typedef struct vbd=
_dev vbd_dev_t ;<BR>static vbd_dev_t *Devices =3D NULL;</DIV>  <DIV>stati=
c struct block_device *bdev =3D NULL;</DIV>  <DIV><BR>static int vbd_endi=
o(struct bio* bio,unsigned int done,int error)<BR>{<BR>&nbsp;struct bio*&=
nbsp; ori_bio;<BR>&nbsp;ori_bio =3D bio-&gt;bi_private;</DIV>  <DIV>&nbsp=
;//printk(KERN_INFO"clone_endio:%d\n",ori_bio-&gt;bi_size);<BR>&nbsp;bio_=
endio(ori_bio,ori_bio-&gt;bi_size,error);<BR>&nbsp;//printk(KERN_INFO"clo=
ne_endio\n");<BR>&nbsp;&nbsp;bio_put(bio);</DIV>  <DIV>&nbsp;return 0;<BR=
>}</DIV>  <DIV><BR>static int
 vbd_make_request(request_queue_t *q, struct bio *bio)<BR>{<BR>&nbsp;//st=
ruct bio_vec *bvec;<BR>&nbsp;struct bio* newbio;<BR>&nbsp;<BR>&nbsp;<BR>&=
nbsp;//sector_t sector =3D bio-&gt;bi_sector;<BR>&nbsp;//sector_t total_s=
ector_num =3D 0;<BR>&nbsp;//int i;</DIV>  <DIV>#if 0<BR>&nbsp;printk("***=
*****************start*************************\n");<BR>&nbsp;if(bio-&gt;=
bi_sector%8!=3D0)printk("**************what we need happen*********\n");<=
BR>&nbsp;printk("bio-&gt;bi_sector=3D%d\n",bio-&gt;bi_sector);<BR>&nbsp;p=
rintk("bio-&gt;bi_vcnt=3D%d\n",bio-&gt;bi_vcnt);<BR>&nbsp;printk("bio-&gt=
;bi_idx=3D%d\n",bio-&gt;bi_idx);<BR>&nbsp;printk("bio-&gt;bi_max_vecs=3D%=
d\n",bio-&gt;bi_max_vecs);<BR>&nbsp;printk("bio-&gt;bi_size=3D%d secotrs\=
n",(bio-&gt;bi_size)&gt;&gt;9);&nbsp;<BR>&nbsp;for(i=3D0;i&lt;bio-&gt;bi_=
vcnt;i++)<BR>&nbsp;{<BR>&nbsp;&nbsp;total_sector_num+=3D(bio-&gt;bi_io_ve=
c[i].bv_len)&gt;&gt;9;<BR>&nbsp;&nbsp;printk("total sector num
 =3D%d\n",total_sector_num);<BR>&nbsp;}<BR>&nbsp;printk("****************=
****finish*************************\n");<BR>#endif </DIV>  <DIV><BR>&nbsp=
;newbio =3D bio_clone(bio,GFP_NOIO); <BR>&nbsp;newbio-&gt;bi_bdev =3D bde=
v;<BR>&nbsp;newbio-&gt;bi_end_io =3D vbd_endio;<BR>&nbsp;newbio-&gt;bi_pr=
ivate =3D bio; </DIV>  <DIV>&nbsp;newbio-&gt;bi_flags &amp;=3D ~(1 &lt;&l=
t; BIO_SEG_VALID);<BR>&nbsp;printk(KERN_INFO"newbio-&gt;bi_flags=3D%d\n",=
newbio-&gt;bi_flags);<BR>&nbsp;printk(KERN_INFO"bio-&gt;bi_flags=3D%d\n",=
bio-&gt;bi_flags); <BR>&nbsp;generic_make_request(newbio);&nbsp;</DIV>  <=
DIV>&nbsp;return 0;<BR>}</DIV>  <DIV><BR>/*<BR>&nbsp;* Open and close.<BR=
>&nbsp;*/</DIV>  <DIV>static int vbd_open(struct inode *inode, struct fil=
e *filp)<BR>{<BR>&nbsp;&nbsp; // static int i=3D10;<BR>&nbsp;vbd_dev_t *v=
bd_dev =3D inode-&gt;i_bdev-&gt;bd_disk-&gt;private_data;<BR>&nbsp;dev_t&=
nbsp; testdev;</DIV>  <DIV>&nbsp;filp_open("/dev/sdb",O_RDWR,0);</DIV>=20
 <DIV><BR>&nbsp;printk("********************start************************=
*\n");<BR>&nbsp;testdev =3D MKDEV(8,16);<BR>&nbsp;bdev =3D bdget(testdev)=
;<BR>&nbsp;if(bdev=3D=3DNULL)<BR>&nbsp;{<BR>&nbsp;&nbsp;printk(KERN_INFO"=
notice:null device**********\n");<BR>&nbsp;&nbsp;return 0;<BR>&nbsp;}</DI=
V>  <DIV><BR>&nbsp;filp-&gt;private_data =3D vbd_dev;<BR>&nbsp;spin_lock(=
&amp;vbd_dev-&gt;lock);<BR>&nbsp;if (! vbd_dev-&gt;users) <BR>&nbsp;{<BR>=
&nbsp;&nbsp;check_disk_change(inode-&gt;i_bdev);<BR>&nbsp;}<BR>&nbsp;vbd_=
dev-&gt;users++;<BR>&nbsp;spin_unlock(&amp;vbd_dev-&gt;lock);<BR>&nbsp;re=
turn 0;<BR>}</DIV>  <DIV><BR>static int vbd_release(struct inode *inode, =
struct file *filp)<BR>{<BR>&nbsp;struct vbd_dev *dev =3D inode-&gt;i_bdev=
-&gt;bd_disk-&gt;private_data;</DIV>  <DIV>&nbsp;spin_lock(&amp;dev-&gt;l=
ock);<BR>&nbsp;dev-&gt;users--;<BR>&nbsp;spin_unlock(&amp;dev-&gt;lock);<=
/DIV>  <DIV>&nbsp;return 0;<BR>}</DIV>  <DIV>/*<BR>&nbsp;* Look for a (si=
mulated) media change.<BR>&nbsp;*/<BR>int
 vbd_media_changed(struct gendisk *gd)<BR>{<BR>&nbsp;struct vbd_dev *dev =
=3D gd-&gt;private_data;<BR>&nbsp;<BR>&nbsp;return dev-&gt;media_change;<=
BR>}</DIV>  <DIV>/*<BR>&nbsp;* Revalidate.&nbsp; WE DO NOT TAKE THE LOCK =
HERE, for fear of deadlocking<BR>&nbsp;* with open.&nbsp; That needs to b=
e reevaluated.<BR>&nbsp;*/<BR>int vbd_revalidate(struct gendisk *gd)<BR>{=
<BR>&nbsp;struct vbd_dev *dev =3D gd-&gt;private_data;<BR>&nbsp;<BR>&nbsp=
;if (dev-&gt;media_change) <BR>&nbsp;{<BR>&nbsp;&nbsp;dev-&gt;media_chang=
e =3D 0;&nbsp;&nbsp;<BR>&nbsp;}<BR>&nbsp;return 0;<BR>}</DIV>  <DIV>&nbsp=
;</DIV>  <DIV>/*<BR>&nbsp;* The ioctl() implementation<BR>&nbsp;*/</DIV> =
 <DIV>int vbd_ioctl (struct inode *inode, struct file *filp,<BR>&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; unsigned int cmd, unsigned long arg)<BR>{</DIV>  <DIV>&nbs=
p;struct hd_geometry geo;<BR>&nbsp;//struct vbd_dev *dev =3D filp-&gt;pri=
vate_data;<BR>&nbsp;&nbsp;&nbsp; //static int
 i=3D0;<BR>&nbsp;<BR>&nbsp;switch(cmd) {<BR>&nbsp;&nbsp;&nbsp;&nbsp; case=
 HDIO_GETGEO:<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;/*<BR>&=
nbsp;&nbsp; * Get geometry: since we are a virtual device, we have to mak=
e<BR>&nbsp;&nbsp; * up something plausible.&nbsp; So we claim 16 sectors,=
 four heads,<BR>&nbsp;&nbsp; * and calculate the corresponding number of =
cylinders.&nbsp; We set the<BR>&nbsp;&nbsp; * start of data at sector fou=
r.<BR>&nbsp;&nbsp; */</DIV>  <DIV>&nbsp;&nbsp;geo.heads =3D 4;<BR>&nbsp;&=
nbsp;geo.sectors =3D 16;<BR>&nbsp;&nbsp;geo.start =3D 4;<BR>&nbsp;&nbsp;i=
f (copy_to_user((void __user *) arg, &amp;geo, sizeof(geo)))<BR>&nbsp;&nb=
sp;&nbsp;return -EFAULT;<BR>&nbsp;&nbsp;return 0;<BR>&nbsp;}<BR>&nbsp;pri=
ntk(KERN_INFO"ioctl:%d\n",cmd);<BR>&nbsp;<BR>&nbsp;return -ENOTTY; /* unk=
nown command */<BR>}</DIV>  <DIV>&nbsp;</DIV>  <DIV>/*<BR>&nbsp;* The dev=
ice operations structure.<BR>&nbsp;*/<BR>static struct block_device_opera=
tions vbd_ops =3D
 {<BR>&nbsp;.owner&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; =3D THIS_MODULE,<BR>&nbsp;.open &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; =3D vbd_open,<BR>&nbsp;.release &nbsp; =3D vbd_releas=
e,<BR>&nbsp;.media_changed&nbsp;&nbsp; =3D vbd_media_changed,<BR>&nbsp;.r=
evalidate_disk =3D vbd_revalidate,<BR>&nbsp;.ioctl&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D vbd_ioctl<BR>};</DIV>  <DIV><BR>/*<BR=
>&nbsp;* Set up our internal device.<BR>&nbsp;*/<BR>static void setup_dev=
ice(struct vbd_dev *dev, int which)<BR>{<BR>&nbsp;/*<BR>&nbsp; * Get some=
 memory.<BR>&nbsp; */<BR>&nbsp;memset (dev, 0, sizeof (struct vbd_dev));<=
BR>&nbsp;spin_lock_init(&amp;dev-&gt;lock);</DIV>  <DIV>&nbsp;dev-&gt;que=
ue =3D blk_alloc_queue(GFP_KERNEL);<BR>&nbsp;if (dev-&gt;queue =3D=3D NUL=
L)<BR>&nbsp;&nbsp;return;</DIV>  <DIV>&nbsp;/**/<BR>&nbsp;blk_queue_make_=
request(dev-&gt;queue, vbd_make_request);<BR>&nbsp;&nbsp;<BR>&nbsp;blk_qu=
eue_hardsect_size(dev-&gt;queue,
 hardsect_size);<BR>&nbsp;dev-&gt;queue-&gt;queuedata =3D dev;</DIV>  <DI=
V>&nbsp;/*<BR>&nbsp; * And the gendisk structure.we just want 1 minor her=
e<BR>&nbsp; */<BR>&nbsp;dev-&gt;gd =3D alloc_disk(VBD_MINORS);<BR>&nbsp;i=
f (! dev-&gt;gd) <BR>&nbsp;{<BR>&nbsp;&nbsp;printk (KERN_NOTICE "alloc_di=
sk failure\n");<BR>&nbsp;&nbsp;return;<BR>&nbsp;}</DIV>  <DIV>&nbsp;/*<BR=
>&nbsp; * Set some other parameters<BR>&nbsp; */<BR>&nbsp;dev-&gt;gd-&gt;=
major =3D vbd_major;<BR>&nbsp;dev-&gt;gd-&gt;first_minor =3D which*VBD_MI=
NORS;<BR>&nbsp;dev-&gt;gd-&gt;fops =3D &amp;vbd_ops;<BR>&nbsp;dev-&gt;gd-=
&gt;queue =3D dev-&gt;queue;<BR>&nbsp;dev-&gt;gd-&gt;private_data =3D dev=
;<BR>&nbsp;snprintf (dev-&gt;gd-&gt;disk_name, 32, "vbd%d", which );<BR>&=
nbsp;set_capacity(dev-&gt;gd, nsectors*(hardsect_size/KERNEL_SECTOR_SIZE)=
);<BR>&nbsp;add_disk(dev-&gt;gd);<BR>&nbsp;return;<BR>&nbsp;<BR>}</DIV>  =
<DIV>&nbsp;</DIV>  <DIV>static int __init vbd_init(void)<BR>{<BR>&nbsp;in=
t i;<BR>&nbsp;/*<BR>&nbsp; * Get
 registered.<BR>&nbsp; */<BR>&nbsp;vbd_major =3D register_blkdev(vbd_majo=
r, "vbd");<BR>&nbsp;if (vbd_major &lt;=3D 0) {<BR>&nbsp;&nbsp;printk(KERN=
_WARNING "vbd: unable to get major number\n");<BR>&nbsp;&nbsp;return -EBU=
SY;<BR>&nbsp;}<BR>&nbsp;/*<BR>&nbsp; * Allocate the device array, and ini=
tialize each one.<BR>&nbsp; */<BR>&nbsp;Devices =3D kmalloc(ndevices*size=
of (struct vbd_dev), GFP_KERNEL);<BR>&nbsp;if (Devices =3D=3D NULL)<BR>&n=
bsp;{<BR>&nbsp;&nbsp;goto out_unregister;<BR>&nbsp;}<BR>&nbsp;for (i =3D =
0; i &lt; ndevices; i++) <BR>&nbsp;{<BR>&nbsp;&nbsp;setup_device(Devices =
+ i, i);<BR>&nbsp;}<BR>&nbsp;&nbsp;&nbsp; <BR>&nbsp;return 0;</DIV>  <DIV=
>&nbsp; out_unregister:<BR>&nbsp;unregister_blkdev(vbd_major, "vbd");<BR>=
&nbsp;return -ENOMEM;<BR>}</DIV>  <DIV>static void vbd_exit(void)<BR>{<BR=
>&nbsp;int i;</DIV>  <DIV>&nbsp;for (i =3D 0; i &lt; ndevices; i++) <BR>&=
nbsp;{<BR>&nbsp;&nbsp;struct vbd_dev *dev =3D Devices + i;<BR>&nbsp;&nbsp=
;if (dev-&gt;gd)
 <BR>&nbsp;&nbsp;{<BR>&nbsp;&nbsp;&nbsp;del_gendisk(dev-&gt;gd);<BR>&nbsp=
;&nbsp;&nbsp;put_disk(dev-&gt;gd);<BR>&nbsp;&nbsp;}<BR>&nbsp;&nbsp;if (de=
v-&gt;queue) <BR>&nbsp;&nbsp;{<BR>&nbsp;&nbsp;&nbsp;blk_cleanup_queue(dev=
-&gt;queue);<BR>&nbsp;&nbsp;}&nbsp;&nbsp;&nbsp;<BR>&nbsp;}<BR>&nbsp;unreg=
ister_blkdev(vbd_major, "vbd");<BR>&nbsp;kfree(Devices);<BR>}<BR>&nbsp;<B=
R>module_init(vbd_init);<BR>module_exit(vbd_exit</DIV><p>&#32;
      <hr size=3D1><a href=3D"https://member.cn.yahoo.com/cnreg/reginfo.h=
tml?id=3D89034" target=3Dblank>=20
@yahoo.cn =D0=C2=D3=F2=C3=FB=A1=A2=CE=DE=CF=DE=C1=BF=A3=AC=BF=EC=C0=B4=C7=
=C0=D7=A2=A3=A1</a>
--0-490143424-1195007433=:85027--


--===============0323595544==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0323595544==--
