From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/4] Open origin before exception store
	initialization
Date: Mon, 15 Mar 2010 10:19:35 -0400
Message-ID: <20100315141935.GC6853@redhat.com>
References: <Pine.LNX.4.64.1003150200290.12526@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1003150200290.12526@hs20-bc2-1.build.redhat.com>
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Mar 15 2010 at  2:00am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Open origin before exception store initialization
> 
> Further patch for chunk size validation requires that the origin
> is open when initializing an exception store.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Reviewed-by: Mike Snitzer <snitzer@redhat.com>
