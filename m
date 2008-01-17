From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Re: Configuring multipath for root device
Date: Thu, 17 Jan 2008 12:38:28 -0800
Message-ID: <110b17190801171238n20563b9eo5090c5b7700fc10f@mail.gmail.com>
References: <110b17190712191302o60d521eaj693410c26d07c1ad@mail.gmail.com>
	<1198099093.26366.32.camel@linuxchandra>
	<110b17190801071219k11749b81n45a7d1d5d35b9413@mail.gmail.com>
	<4783239C.7020206@suse.de>
	<110b17190801151825ofd63e20yd9d4f01be7b67407@mail.gmail.com>
	<20080116173649.GA30593@us.ibm.com>
	<110b17190801161049o127a22edq1888f9184156b52@mail.gmail.com>
	<20080117202145.GC7083@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080117202145.GC7083@us.ibm.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

# ls -al /dev/system/
total 0
drwx------  2 root root   80 Jan 16 17:44 .
drwxr-xr-x 11 root root 6660 Jan 16 17:46 ..
lrwxrwxrwx  1 root root   23 Jan 16 17:44 root -> /dev/mapper/system-root
lrwxrwxrwx  1 root root   23 Jan 16 17:44 swap -> /dev/mapper/system-swap

Yes, /dev/system/root and swap are links, as shown above.

About volume labels, I tried assigning label to mount /dev/system/root
to label-root but it would fail.
I tried doing it through YaST/partitioner and it failed with the
following error:

"Failure occurred during following action:
Setting label on /dev/system/root to label-root.

System error code was : -3024"

Is there any other way to change the label.


Further information:
when I try to run "multipath -v3", it would not create any map , with
following error
222f2000155c11879: set ACT_CREATE (map does not exist)
222f2000155c11879: domap (0) failure for create/reload map

Thanks and Regards,
Pradipmaya.

On Jan 17, 2008 12:21 PM,  <malahal@us.ibm.com> wrote:
> Pradipmaya Maharana [pradipmaya@gmail.com] wrote:
> >
> > Let me know if you need any other information.
> >
> > Malahal, are you saying that I should mount the "/" and "swap" by
> > volume label and it should be able to boot fine?
>
> What are /dev/system/root and /dev/system/swap? Are they symlinks or do
> they have same major/minor number of corresponding LVM LVs?
> Yes, volume labels may work but I never booted SLES with LVM.
>
> -Malahal.
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
