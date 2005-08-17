From: Ed Wilts <ewilts@ewilts.org>
Subject: Re: Path updation while controller is rebooted.
Date: Wed, 17 Aug 2005 12:21:07 -0500
Message-ID: <20050817172107.GC26171@www.ewilts.org>
References: <3456F611E9329441B12FBB24447B3FA002850279@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <3456F611E9329441B12FBB24447B3FA002850279@bgeexc01.asiapacific.cpqcorp.net>
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

On Wed, Aug 17, 2005 at 08:54:17PM +0530, Murthy, Narasimha Doraswamy (STSD) wrote:
> With latest RHEL 4 DM modules and user space tools, when the Storage
> controller is rebooted and if "multipath -ll" is executed, the command
> is hung for a while (because of retries) and outputs the following
> status:

Which SAN controllers are you using?  Are they active/active (like an
EVA8000) or active/passive (like an EVA5000)?

If they're active/passive, then the dm stuff isn't supported yet.
That's coming in U2.

        .../Ed

--
Ed Wilts, RHCE
Mounds View, MN, USA
mailto:ewilts@ewilts.org
Member #1, Red Hat Community Ambassador Program
