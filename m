From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/4] Add dm_snap_origin function
Date: Mon, 15 Mar 2010 10:20:02 -0400
Message-ID: <20100315142001.GD6853@redhat.com>
References: <Pine.LNX.4.64.1003150201010.12526@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1003150201010.12526@hs20-bc2-1.build.redhat.com>
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

On Mon, Mar 15 2010 at  2:01am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Add dm_snap_origin function
> 
> Add function dm_snap_origin, it will be used for checking chunk size against
> origin sector size.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Reviewed-by: Mike Snitzer <snitzer@redhat.com>
