From: Luca Berra <bluca@comedia.it>
Subject: Re: Re: LVM on dmraid breakage
Date: Fri, 10 Aug 2007 07:09:07 +0200
Message-ID: <20070810050907.GA10164@percy.comedia.it>
References: <46B0EAEF.6090305@cfl.rr.com>
	<20070802065012.GA28687@percy.comedia.it>
	<46B1B5E1.1050406@redhat.com> <46B251BB.1010004@cfl.rr.com>
	<20070807210359.GA2064@agk.fab.redhat.com>
	<46BA2FCC.1040001@cfl.rr.com>
	<20070808214538.GR2064@agk.fab.redhat.com>
	<46BB4E86.7090000@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <46BB4E86.7090000@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: ataraid-list@redhat.com, device-mapper development <dm-devel@redhat.com>, linux-lvm@redhat.com
List-Id: dm-devel.ids

On Thu, Aug 09, 2007 at 01:27:34PM -0400, Phillip Susi wrote:
>Alasdair G Kergon wrote:
>>But I don't yet see why it didn't also open the other devices, write a 
>>warning
>>message about duplicate IDs, and do the right thing and give them
>>precedence.
>
>Why would it open the other devices?  LVM does not scan /dev/mapper/*, 
>only /dev/sd*.  Since it does not scan the /dev/mapper devices for pvs, 
>it sees no duplicates and can not "do the right thing".

LVM scans the whole /dev directory, unless you configure it otherwise.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
