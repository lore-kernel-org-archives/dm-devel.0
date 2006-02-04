From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: default value for rr_min_io too high?
Date: Sat, 04 Feb 2006 10:37:27 +0100
Message-ID: <1139045847.17909.6.camel@zezette>
References: <43CEB625.9000503@netapp.com>
	<20060122174324.GC4280@agk.surrey.redhat.com>
	<20060203163354.GB5410@pundit>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060203163354.GB5410@pundit>
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
List-Id: dm-devel.ids

On ven, 2006-02-03 at 17:33 +0100, Christophe Varoqui wrote:
> On Sun, Jan 22, 2006 at 05:43:24PM +0000, Alasdair G Kergon wrote:
> > On Wed, Jan 18, 2006 at 04:41:57PM -0500, David Wysochanski wrote:
> > > I'm wondering where the value of 1000 came from, and
> > 
> > Thin air.
> > 
> > > whether that's really a good default.
> >  
> > Unlikely.
> > 
> > That's why we made it configurable - to make it easy to try out
> > different values and use whatever you find best.
> > 
> I'm less and less confident we can find good figures, even for a specific workload.
> Here is another round of numbers.
> 
> Is there still a plan for pluging the elevator in the devmapper device ?
> This could help us produce predictable figures (the ones admins like).
> 
I read in the LWN article titled "Request Queues I" at
http://lwn.net/Articles/27055/ that :

"One request queue can be shared across multiple physical drives, but
the normal usage is to create a separate queue for each drive."

Is it still the case ?

Would it be better to coalesce the different paths request queues upon
multipath map load and re-split them upon unload ?

> Regards,
> cvaroqui
> 
> Hardware :
> - 2x2Gb/s Qlogic HBA
> - 1x100GB Vraid1 in a 2C2D EVA3000 StorageWorks array
> 
> Test :
> - 1 streaming read at a time
> - Variations of rr_min_io and dd blocksize
> 
> Results :
> 
> min_io				dd block size (kB)				
> 	4	8	16	32	64	128	256	512	1024
> 
> 8	111	53	51	47	32	59	50	41	61
> 16	28	79	46	55	112	52	83	68	61
> 32	41	33	46	31	116	36	75	106	37
> 64	48	36	67	36	81	54	71	53	47
> 128	46	46	57	54	66	54	66	59	44
> 256	56	50	63	63	69	53	57	55	63
> 512	56	49	55	58	66	60	88	56	57
> 1024	62	54	70	62	91	82	89	61	61
> 
> Script used :
> #!/bin/bash
> 
> MULTIPATH=/root/foo/multipath/multipath
> DEV=/dev/mapper/mpath1
> DD="sg_dd sync=1 time=1 dio=1"
> SIZE="1024*1024"
> MINIO="8 16 32 64 128 256 512 1024"
> BS="4 8 16 32 64 128 256 512 1024"
> 
> #
> # @1 : desired min_io
> #
> function set_minio
> {
>         sed s/XX/$1/ /root/multipath.conf > /etc/multipath.conf
>         $MULTIPATH $MULTIPATH_OPT >/dev/nul
> }
> 
> # header
> echo "0 $BS"
> 
> for minio in $(echo $MINIO)
> do
>         set_minio $minio
>         echo -n "$minio "
>         for bs in $(echo $BS)
>         do
>                 count=$(($SIZE/$bs))
>                 echo -n "$($DD if=$DEV of=/dev/null bs=${bs}k count=${count} 2>&1|head -1|awk '{print $8}') "
>         done
>         echo
> done
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
