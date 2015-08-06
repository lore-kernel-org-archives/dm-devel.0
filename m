From: NeilBrown <neilb@suse.com>
Subject: Re: [dm-devel] kernel BUG at drivers/scsi/scsi_lib.c:1101! observed
 during md5sum for one file on (RAID4->RAID0) device
Date: Fri, 7 Aug 2015 09:15:50 +1000
Message-ID: <20150807091550.44973f07@noble>
References: <1710310402.852769.1438246982906.JavaMail.zimbra@redhat.com>
	<1438262886.2229.1.camel@HansenPartnership.com>
	<20150731112058.6e97b491@noble>
	<2095050658.4693864.1438843965011.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <2095050658.4693864.1438843965011.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Yi Zhang <yizhan@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-raid@vger.kernel.org, Jes Sorensen <Jes.Sorensen@redhat.com>, xni@redhat.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: dm-devel.ids

On Thu, 6 Aug 2015 02:52:45 -0400 (EDT) Yi Zhang <yizhan@redhat.com>
wrote:

> Hi Neil
> I test 10 times with below patch on Linux 4.2-rc5, didn't reproduce the issue, thanks.
> 
> 

Thanks for the confirmation.
I will be submitting it for 4.3 and then it will flow into -stable
kernels.

NeilBrown
