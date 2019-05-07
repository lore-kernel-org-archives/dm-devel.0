From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 08/10] dm-integrity: add a bitmap mode
Date: Tue, 7 May 2019 14:51:54 -0400
Message-ID: <20190507185154.GB24320@redhat.com>
References: <20190429125746.036036640@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190429125746.036036640@debian-a64.vm>
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
Cc: Ondrej Kozina <okozina@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Mon, Apr 29 2019 at  8:57am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Add a new bitmap mode for dm-integrity.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

This patch header needs much more detail.

Can you please be as informative and detailed as possible about what
this new bitmap mode is (what constraints it has, where it is expected
to be useful, etc)?  Also, if you have them, provide some benchmarks
that showcase its benefits.

Thanks,
Mike
