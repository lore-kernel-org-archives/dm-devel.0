From: Zhengyuan Liu <liuzhengyuang521@gmail.com>
Subject: Re: super-block written got dislocation while 64K
	PAGE_SIZE enable.
Date: Thu, 2 Jun 2016 11:49:59 +0800
Message-ID: <CAOOPZo4V4WyxsniDbpC9SOM=+Cp0OapGnXa4xot9xYUkpBzGjQ@mail.gmail.com>
References: <CAOOPZo6+dtw9VWHnMhR8LEeFxEdNGOMthCw-PqRNmnLP2eAq1g@mail.gmail.com>
	<alpine.LRH.2.11.1606011057370.9562@mail.ewheeler.net>
	<20160601231633.GA32542@kmo-pixel>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8834368123680032586=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160601231633.GA32542@kmo-pixel>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, dm-devel@redhat.com, Eric Wheeler <bcache@lists.ewheeler.net>, huhai@kylinos.cn
List-Id: dm-devel.ids

--===============8834368123680032586==
Content-Type: multipart/alternative; boundary=94eb2c0433fe0e04060534438055

--94eb2c0433fe0e04060534438055
Content-Type: text/plain; charset=UTF-8

To support arbitrary page size for superblock,include 4K/8K/64K currently,
the off_set of SB_SECTOR should be a LCM(least common multiple) and that is
64. I redefine macro SB_SECTOR and BDEV_DATA_START_DEFAULT just as bellow
patch showed:
        diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
        index ef567cd..1622f44 100644
        --- a/drivers/md/bcache/super.c
        +++ b/drivers/md/bcache/super.c
        @@ -74,7 +74,7 @@ static const char *read_super(struct cache_sb
*sb, struct block_device *bdev,
         {
                const char *err;
                struct cache_sb *s;
        -       struct buffer_head *bh = __bread(bdev, 1, SB_SIZE);
        +       *struct buffer_head *bh = __bread(bdev, 16, SB_SIZE);*
                unsigned i;

                if (!bh)
        diff --git a/include/uapi/linux/bcache.h
b/include/uapi/linux/bcache.h
        index 22b6ad3..eb948c8 100644
        --- a/include/uapi/linux/bcache.h
        +++ b/include/uapi/linux/bcache.h
        @@ -144,14 +144,14 @@ static inline struct bkey *bkey_idx(const
struct bkey *k, unsigned nr_keys)
         #define BCACHE_SB_VERSION_BDEV_WITH_OFFSET 4
         #define BCACHE_SB_MAX_VERSION          4

        -#define SB_SECTOR                      8
        *+#define SB_SECTOR                      128*
         #define SB_SIZE                                4096
         #define SB_LABEL_SIZE                  32
         #define SB_JOURNAL_BUCKETS             256U
         /* SB_JOURNAL_BUCKETS must be divisible by BITS_PER_LONG */
         #define MAX_CACHES_PER_SET             8

        -#define BDEV_DATA_START_DEFAULT                16      /* sectors
*/
        *+#define BDEV_DATA_START_DEFAULT                    256 /* sectors
*/*

         struct cache_sb {
                __u64                   csum;

The second arg of *__bread(bdev, 16, SB_SIZE)  *has unit of block size and
it need be relocated too.
To suitable this change, bcache-tools need be fixed up too.
As for btree_node_size issues about page size, expecting somebody to commit
a patch.

Kent, maybe you could use qemu to simulate ARM64 arch and there is always
ubuntu image for ARM64 on the internet.

2016-06-02 7:16 GMT+08:00 Kent Overstreet <kent.overstreet@gmail.com>:

> On Wed, Jun 01, 2016 at 11:05:20AM -0700, Eric Wheeler wrote:
> > On Wed, 1 Jun 2016, Zhengyuan Liu wrote:
> >
> > > Hi, I have created a mapped block device (bcach0) using make-bcache on
> > > ARM64 server which has kernel enable 64K page size. However, the
> > > bcach0 disappeared after the server reboot and there is no or dirty
> > > metadata on super block of both cache device and back device . The
> > > output of command  bcache-super-show was as bellow showed:
> > >    [root@master Linux-4.4-LTS-storage]# bcache-super-show  /dev/sdb
> > >    sb.magic bad magic
> > >    Invalid superblock (bad magic)
> > > /dev/sdb was the backing device and cache device got bad magic too.
> > >
> > > I tried to traced the written process of super block in bcache source
> > > code and found that is the issue of PAGE_SIZE. It seems that the
> > > bcache  was designed only considering for 4K PAGE_SIZE and it works
> > > right only on 4K PAGE_SIZE exactly. To make bcache work correctly on
> > > 64K PAGE_SIZE, I committed a patch as bellow showd:
> > >     diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> > >     index 330cd6e..ef567cd 100644
> > >     --- a/drivers/md/bcache/super.c
> > >     +++ b/drivers/md/bcache/super.c
> > >     @@ -224,6 +224,12 @@ static void __write_super(struct cache_sb
> > > *sb, struct bio     *bio
> > >         bio->bi_iter.bi_size    = SB_SIZE;
> > >         bch_bio_map(bio, NULL);
> > >
> > >     +#ifdef CONFIG_ARM64_64K_PAGES
> > >     +       out = (struct cache_sb *)((char *)out + (SB_SECTOR<<9));
> > >     +       pr_debug("sb_page_adress %x, sb_address %x,page_size
> > >           %d\n",page_address(bio
> > >     +       bio->bi_io_vec[0].bv_offset = (SB_SECTOR<<9);
> > >     +#endif
> > >
> > >         out->offset             = cpu_to_le64(sb->offset);
> > >         out->version            = cpu_to_le64(sb->version);
> > >
> > > Does it not recommend to use bcache on 64K PAGE_SIZE? or it only
> > > considers for 4K PAGE_SIZE for bcache currently?
> > > Maybe it is more suitable  for me to redefine some macro such as
> > > SB_SECTOR, BDEV_DATA_START_DEFAULT to make bcache work correctly on
> > > both 64K PAGE_SIZE and 4K PAGE_SIZE.
> >
> > I think a patch to support arbitrary page size would be great.  Can
> > you write the macros in terms of PAGE_SIZE or PAGE_SHIFT?
>
> It shouldn't be referencing PAGE_SIZE at all - creating a new macro
> (BCH_SB_SIZE, perhaps) is the correct approach.
>
> The code that allocates the buffer for the superblock will have to be fixed
> too - right now it's probably using __get_free_page(), it should probably
> just
> be switched to kmalloc().
>
> > (Out of curiosity, what ARM64 hardware are you using?)
> >
> > Kent, this may affect bcachefs too.  Can you think of any other places
> > that might have PAGE_SIZE!=4k issues?
>
> Oh, there's probably a couple. There's probably some stuff that'll break if
> btree_node_size is smaller than PAGE_SIZE, too...
>
> If it turns out to be too much for Zhengyuan, I can probably fix upstream
> too
> (but I don't have any hardware to test with).
>

--94eb2c0433fe0e04060534438055
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">To support arbitrary page size for superblock,include 4K/8=
K/64K currently, the off_set of SB_SECTOR should be a LCM(least common mult=
iple) and that is 64. I redefine macro SB_SECTOR and BDEV_DATA_START_DEFAUL=
T just as bellow patch showed:<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 diff --git a/=
drivers/md/bcache/super.c b/drivers/md/bcache/super.c<br>=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 index ef567cd..1622f44 100644<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 ---=
 a/drivers/md/bcache/super.c<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 +++ b/drivers/m=
d/bcache/super.c<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 @@ -74,7 +74,7 @@ static co=
nst char *read_super(struct cache_sb *sb, struct block_device *bdev,<br>=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0{<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 const char *err;<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 struct cache_sb *s;<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 - =
=C2=A0 =C2=A0 =C2=A0 struct buffer_head *bh =3D __bread(bdev, 1, SB_SIZE);<=
br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 + =C2=A0 =C2=A0 =C2=A0 <b>struct buffer_head=
 *bh =3D __bread(bdev, 16, SB_SIZE);</b><br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 unsigned i;<br>=C2=A0<br>=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!bh)<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 dif=
f --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h<br>=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 index 22b6ad3..eb948c8 100644<br>=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 --- a/include/uapi/linux/bcache.h<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 +++ b/include/uapi/linux/bcache.h<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 @@ -144,1=
4 +144,14 @@ static inline struct bkey *bkey_idx(const struct bkey *k, unsi=
gned nr_keys)<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0#define BCACHE_SB_VERSIO=
N_BDEV_WITH_OFFSET 4<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0#define BCACHE_SB=
_MAX_VERSION =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A04<br>=C2=A0<br>=C2=A0 =C2=A0=
 =C2=A0 =C2=A0 -#define SB_SECTOR =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A08<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 <b>+#de=
fine SB_SECTOR =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0128</b><br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0#define SB_SI=
ZE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A04096<br>=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0#define SB_LABEL_SIZE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A032<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0#define SB_JOUR=
NAL_BUCKETS =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 256U<br>=C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0/* SB_JOURNAL_BUCKETS must be divisible by BITS_PER_LO=
NG */<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0#define MAX_CACHES_PER_SET =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 8<br>=C2=A0<br>=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 -#define BDEV_DATA_START_DEFAULT =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A016 =C2=A0 =C2=A0 =C2=A0/* sectors */<br>=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 <b>+#define BDEV_DATA_START_DEFAULT =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0256 /* sectors */</b><br>=C2=
=A0<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct cache_sb {<br>=C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __u64 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 csum;<br><div class=3D"gmail_extra">=
<br></div><div class=3D"gmail_extra">The second arg of=C2=A0<b>__bread(bdev=
, 16, SB_SIZE) =C2=A0</b>has unit of block size and it need be relocated to=
o.</div><div class=3D"gmail_extra">To suitable this change, bcache-tools ne=
ed be fixed up too.=C2=A0</div><div class=3D"gmail_extra">As for btree_node=
_size issues about page size, expecting somebody to commit a patch.</div><d=
iv class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">Kent, maybe y=
ou could use qemu to simulate ARM64 arch and there is always ubuntu image f=
or ARM64 on the internet.=C2=A0</div><div class=3D"gmail_extra"><br><div cl=
ass=3D"gmail_quote">2016-06-02 7:16 GMT+08:00 Kent Overstreet <span dir=3D"=
ltr">&lt;<a href=3D"mailto:kent.overstreet@gmail.com" target=3D"_blank">ken=
t.overstreet@gmail.com</a>&gt;</span>:<br><blockquote class=3D"gmail_quote"=
 style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:=
rgb(204,204,204);border-left-style:solid;padding-left:1ex"><div class=3D"">=
<div class=3D"h5">On Wed, Jun 01, 2016 at 11:05:20AM -0700, Eric Wheeler wr=
ote:<br>
&gt; On Wed, 1 Jun 2016, Zhengyuan Liu wrote:<br>
&gt;<br>
&gt; &gt; Hi, I have created a mapped block device (bcach0) using make-bcac=
he on<br>
&gt; &gt; ARM64 server which has kernel enable 64K page size. However, the<=
br>
&gt; &gt; bcach0 disappeared after the server reboot and there is no or dir=
ty<br>
&gt; &gt; metadata on super block of both cache device and back device . Th=
e<br>
&gt; &gt; output of command=C2=A0 bcache-super-show was as bellow showed:<b=
r>
&gt; &gt;=C2=A0 =C2=A0 [root@master Linux-4.4-LTS-storage]# bcache-super-sh=
ow=C2=A0 /dev/sdb<br>
&gt; &gt;=C2=A0 =C2=A0 sb.magic bad magic<br>
&gt; &gt;=C2=A0 =C2=A0 Invalid superblock (bad magic)<br>
&gt; &gt; /dev/sdb was the backing device and cache device got bad magic to=
o.<br>
&gt; &gt;<br>
&gt; &gt; I tried to traced the written process of super block in bcache so=
urce<br>
&gt; &gt; code and found that is the issue of PAGE_SIZE. It seems that the<=
br>
&gt; &gt; bcache=C2=A0 was designed only considering for 4K PAGE_SIZE and i=
t works<br>
&gt; &gt; right only on 4K PAGE_SIZE exactly. To make bcache work correctly=
 on<br>
&gt; &gt; 64K PAGE_SIZE, I committed a patch as bellow showd:<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0diff --git a/drivers/md/bcache/super.c b/drive=
rs/md/bcache/super.c<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0index 330cd6e..ef567cd 100644<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0--- a/drivers/md/bcache/super.c<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0+++ b/drivers/md/bcache/super.c<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0@@ -224,6 +224,12 @@ static void __write_super=
(struct cache_sb<br>
&gt; &gt; *sb, struct bio=C2=A0 =C2=A0 =C2=A0*bio<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio-&gt;bi_iter.bi_size=C2=A0 =
=C2=A0 =3D SB_SIZE;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bch_bio_map(bio, NULL);<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0+#ifdef CONFIG_ARM64_64K_PAGES<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0+=C2=A0 =C2=A0 =C2=A0 =C2=A0out =3D (struct ca=
che_sb *)((char *)out + (SB_SECTOR&lt;&lt;9));<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0+=C2=A0 =C2=A0 =C2=A0 =C2=A0pr_debug(&quot;sb_=
page_adress %x, sb_address %x,page_size<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0%d\n&quot;,page_address(b=
io<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0+=C2=A0 =C2=A0 =C2=A0 =C2=A0bio-&gt;bi_io_vec[=
0].bv_offset =3D (SB_SECTOR&lt;&lt;9);<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0+#endif<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0out-&gt;offset=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D cpu_to_le64(sb-&gt;offset);<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0out-&gt;version=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =3D cpu_to_le64(sb-&gt;version);<br>
&gt; &gt;<br>
&gt; &gt; Does it not recommend to use bcache on 64K PAGE_SIZE? or it only<=
br>
&gt; &gt; considers for 4K PAGE_SIZE for bcache currently?<br>
&gt; &gt; Maybe it is more suitable=C2=A0 for me to redefine some macro suc=
h as<br>
&gt; &gt; SB_SECTOR, BDEV_DATA_START_DEFAULT to make bcache work correctly =
on<br>
&gt; &gt; both 64K PAGE_SIZE and 4K PAGE_SIZE.<br>
&gt;<br>
&gt; I think a patch to support arbitrary page size would be great.=C2=A0 C=
an<br>
&gt; you write the macros in terms of PAGE_SIZE or PAGE_SHIFT?<br>
<br>
</div></div>It shouldn&#39;t be referencing PAGE_SIZE at all - creating a n=
ew macro<br>
(BCH_SB_SIZE, perhaps) is the correct approach.<br>
<br>
The code that allocates the buffer for the superblock will have to be fixed=
<br>
too - right now it&#39;s probably using __get_free_page(), it should probab=
ly just<br>
be switched to kmalloc().<br>
<span class=3D""><br>
&gt; (Out of curiosity, what ARM64 hardware are you using?)<br>
&gt;<br>
&gt; Kent, this may affect bcachefs too.=C2=A0 Can you think of any other p=
laces<br>
&gt; that might have PAGE_SIZE!=3D4k issues?<br>
<br>
</span>Oh, there&#39;s probably a couple. There&#39;s probably some stuff t=
hat&#39;ll break if<br>
btree_node_size is smaller than PAGE_SIZE, too...<br>
<br>
If it turns out to be too much for Zhengyuan, I can probably fix upstream t=
oo<br>
(but I don&#39;t have any hardware to test with).<br>
</blockquote></div><br></div></div>

--94eb2c0433fe0e04060534438055--


--===============8834368123680032586==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8834368123680032586==--
