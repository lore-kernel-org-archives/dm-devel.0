From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] Support HDIO_GETGEO on device-mapper volumes
Date: Fri, 10 Feb 2006 00:14:15 -0800
Message-ID: <43EC4B57.9000408@us.ibm.com>
References: <43EBEDD0.60608@us.ibm.com> <43EC218A.9000402@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751195AbWBJIOP@vger.kernel.org>
In-Reply-To: <43EC218A.9000402@cfl.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: dm-devel@redhat.com, Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Phillip Susi wrote:
> Hrm... when I setup my system on a dmraid controlled hardware fakeraid 
> raid-0, I just gave grub a suitable geometry command since it couldn't 
> auto detect it.  I suppose this would make that unnecessary.

That was the intent. :)

> I think that ultimately, grub shouldn't care about the geometry since 
> that information has been obsolete for years.  If it can't detect the 
> geometry, then it should just assume the system supports LBA and to hell 
> with using made up geometry numbers.

You certainly get my vote for that.  Consider, however, that sd_mod 
invents geometry numbers for whomever is silly enough to call 
HDIO_GETGEO, even though CHS doesn't make sense _at all_ on a SCSI disk, 
which never had that mode of addressing in the first place.  I wonder if 
there exists users of dmraid who have systems that can't do LBA?  (Seems 
unlikely though...)

Phillip... are you the person working on dmraid support in Ubuntu?  For 
the first time, I boot Ubuntu off that HostRAID array this afternoon 
without the need for a helper disk and with dmraid in the initramfs.  I 
appreciated the howto. :)

--D
