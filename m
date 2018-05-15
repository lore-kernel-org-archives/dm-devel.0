From: "Martin Wilck" <Martin.Wilck@suse.com>
Subject: Re: [release] multipath-tools 0.7.7
Date: Tue, 15 May 2018 12:10:42 +0200
Message-ID: <5AFAB222020000F6002525FA@smtp.nue.novell.com>
References: <CABr-Gnf_5ADS_OsKHJO=2zqykUoUkMkXHXOe67SK=MnX_2DbCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-Gnf_5ADS_OsKHJO=2zqykUoUkMkXHXOe67SK=MnX_2DbCA@mail.gmail.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello Christophe,

Christophe Varoqui <christophe.varoqui@opensvc.com> wrote on 05/11/18 10:57 AM:
> Hi,
> I merged the reviewed patches from March 27th up to now, and released 0.7.7.
> Thanks,
> Christophe.

Two of my patches seem to be missing:

 - libmultipath: don't reject maps with undefined prio
   Reviewed by Ben in https://www.redhat.com/archives/dm-devel/2018-March/msg00545.html
   
 - multipathd: handle errors in uxlsnr as fatal
   reviewed by Ben in https://www.redhat.com/archives/dm-devel/2018-March/msg00433.html

Regards,
Martin
