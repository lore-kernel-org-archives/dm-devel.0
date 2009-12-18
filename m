From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Fri, 18 Dec 2009 15:39:40 +0100
Message-ID: <m3eims1h3n.fsf@intrepid.localdomain>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<200912171618.32882.bzolnier@gmail.com>
	<alpine.LRH.2.00.0912181400130.21496@twin.jikos.cz>
	<200912181455.34664.bzolnier@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200912181455.34664.bzolnier@gmail.com> (Bartlomiej
	Zolnierkiewicz's message of "Fri, 18 Dec 2009 14:55:34 +0100")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> writes:

>> 	set_le_ih_k_offset(ih,
>> 			   le_ih_k_offset(ih) +
>> 			   (tb->
>> 			    lbytes <<
>> 			    (is_indirect_le_ih
>> 			     (ih) ? tb->tb_sb->
>> 			     s_blocksize_bits -
>> 			     UNFM_P_SHIFT :
>> 			     0)));

> Firstly what kind of a function parameter is that:

It's hard to tell without unmangling the line first :-)
-- 
Krzysztof Halasa
