From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm snapshot: use unsigned integer chunk size
Date: Fri, 2 Oct 2009 23:27:16 +0100
Message-ID: <20091002222716.GA5351@agk-dp.fab.redhat.com>
References: <20090930144110.GA16605@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090930144110.GA16605@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Sep 30, 2009 at 10:41:10AM -0400, Mike Snitzer wrote:
> Maximum chunk size is 512kB, 

Can you confirm that a supplied chunk size of 4294971392, for example, still
gets rejected?

> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>

> -	unsigned long chunk_size_ulong;
> +	unsigned chunk_size;

> -	chunk_size_ulong = simple_strtoul(chunk_size_arg, &value, 10);
> +	chunk_size = simple_strtoul(chunk_size_arg, &value, 10);

Alasdair
