From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: ios and sectors should be incremented on completion
Date: Wed, 1 Oct 2014 08:26:05 +0000
Message-ID: <542BBA9C.7010808@ce.jp.nec.com>
References: <20140926181236.177920a7a88d25a2d7189093@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140926181236.177920a7a88d25a2d7189093@valinux.co.jp>
Content-Language: ja-JP
Content-ID: <50FEA5384A3EE648BA00202C33A16372@gisp.nec.co.jp>
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

On 09/26/14 18:12, Akira Hayakawa wrote:
> I seems DM increments stats (ios and sectors) before completion.
> Why don't you do this in dec_pending?
> block/stat.txt says these values are incremented when I/O request completes.
> 
> Is this to be fixed or do you have some justifications for this behavior?

Do you have a problem with the current behavior other than the document?

AFAIR, dm increments ios/sectors at submission because md did.
And other bio-based drivers such as drbd and nvme seem to have followed
the precedence.

While md has a reason to do so (some md personalities just remaps bios
and doesn't track completion), dm should be able to collect stat
in dec_pending as it always clones.

So, I think it's ok to move ios/sectors counting to end_io_acct().
It might make tools like iostat happier.
You might want to fix other bio-based drivers as well.

-- 
Jun'ichi Nomura, NEC Corporation
