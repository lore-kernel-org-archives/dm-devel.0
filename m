From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH] kpartx: partitions of mapped devices cannot
 be created in redhat OS
Date: Thu, 8 Sep 2016 10:54:48 -0500
Message-ID: <20160908155448.GI7016@octiron.msp.redhat.com>
References: <1472469122-12952-1-git-send-email-tang.junhui@zte.com.cn>
	<1473161968.15423.1.camel@researchut.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1473161968.15423.1.camel@researchut.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ritesh Raj Sarraf <rrs@researchut.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Sep 06, 2016 at 05:09:28PM +0530, Ritesh Raj Sarraf wrote:
> Yes. In Debian too, we've been hit by something similar.
> 
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=827412
> https://anonscm.debian.org/cgit/pkg-lvm/multipath-tools.git/tree/debian/dmsetup_
> env

I just want to point out that we don't actually distribute kpartx.rules
in the redhat releases of the multipath-tools.

-Ben

> 
> 
> 
> On Mon, 2016-08-29 at 19:12 +0800, tang.junhui@zte.com.cn wrote:
> > From: "tang.junhui" <tang.junhui@zte.com.cn>
> > 
> > Environment variables such as DM_TABLE_STATE are used in kpartx.rules which
> > exported
> > by "dmsetup export" in previous udev rules in SuSE OS, however, there is no
> > such command
> > "dmsetup export" in redhat OS, so these environment variables are not
> > initialized and
> > partitions cannot be created. This patch replace "dmsetup export" with
> > "dmsetup info"
> > to get the status of mapped device, which can work well both in SuSE and
> > redhat OS.
> -- 
> Given the large number of mailing lists I follow, I request you to CC
> me in replies for quicker response



> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
