From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: Re: Failed pvmove causes freeze of lvm in Total
Date: Thu, 13 Dec 2012 12:55:29 +0100
Message-ID: <CAG2kNCw9YQK5kVvC6+cbASBH+X3HMzdrhV83PRYah2GKn08j9w@mail.gmail.com>
References: <CAG2kNCxa2VDW+B=iXqf76m=XFy8D8YDuy0QcAdPpCzOi2cFzNg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAG2kNCxa2VDW+B=iXqf76m=XFy8D8YDuy0QcAdPpCzOi2cFzNg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Thu, Dec 13, 2012 at 8:20 AM, Gianluca Cecchi wrote:
> Hello,
> Rhel 5.8.
> Lvm tags enabled.
> So, my pvmove command fails because it cannot activate the temporary
> mirror...
> But now on, all command related to lvm, also for other vg, completely
> freeze..
> Any wait to unblock?
> I tried removing the volume_list directive in lvm.conf, but no way...
> I would like to avoid doing power off if possible..
> Thanks Gianluca

Sorry.. I noticed it was sort off-topic for this list and posted to
linux-lvm too where I was given a working solution by Zdenek Kabelac
For reference:
https://www.redhat.com/archives/linux-lvm/2012-December/msg00009.html

Bye
