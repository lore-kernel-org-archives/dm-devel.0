From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 6/7] dm-crypt: make it possible to disable
 offload to thread
Date: Mon, 16 Feb 2015 09:08:48 -0500
Message-ID: <20150216140848.GA20303@redhat.com>
References: <alpine.LRH.2.02.1502130826050.6449@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1502130826050.6449@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ondrej Kozina <okozina@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Fri, Feb 13 2015 at  8:27am -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> There are some situation where offloading bios to a thread degrades
> performance twice, so we make an option to disable this feature. The
> feature can be disabled by passing performance_no_offload as an optional
> table argument performance_no_offload.
> 
> We increase target version to 14 so that userspace can be aware of this
> feature.
> 
> The default is to offload bios because for CFQ it is benefical to do so.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

I changed the option to 'submit_writes_from_encrypt_threads', see:

https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.20&id=70a296ba4bfff0355fd57d29ad607ad79590635d

I'm open to other names for this option but felt your original
'performance_no_offload' was too opaque to users.
