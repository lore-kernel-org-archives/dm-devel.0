From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] dm: Add support for data integrity to DM
Date: Mon, 29 Sep 2008 11:05:02 -0400
Message-ID: <yq163off0wx.fsf@sermon.lab.mkp.net>
References: <20080920211433.9e1a6872.akpm@linux-foundation.org>
	<1222195272-18674-3-git-send-email-martin.petersen@oracle.com>
	<20080923.152942.41629825.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080923.152942.41629825.k-ueda@ct.jp.nec.com> (Kiyoshi Ueda's
	message of "Tue\, 23 Sep 2008 15\:29\:42 -0400 \(EDT\)")
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
Cc: k-ueda@ct.jp.nec.com, agk@sourceware.org, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, jens.axboe@oracle.com
List-Id: dm-devel.ids

>>>>> "Kiyoshi" == Kiyoshi Ueda <k-ueda@ct.jp.nec.com> writes:

Kiyoshi> Creating another function (e.g. dm_table_set_integrity(t,
Kiyoshi> md)) may be better, since then you wouldn't need dm_queue()
Kiyoshi> nor need to change the function interface of
Kiyoshi> dm_table_set_restrictions() I think.

You are right.  Originally I had more reasons for having that calling
interface change but that's no longer the case.  I'll fan the
integrity bits out to a separate function.

-- 
Martin K. Petersen	Oracle Linux Engineering
