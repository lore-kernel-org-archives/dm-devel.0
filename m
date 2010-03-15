From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/4] Iterate both origin and snapshot devices
Date: Mon, 15 Mar 2010 10:14:11 -0400
Message-ID: <20100315141410.GB6853@redhat.com>
References: <Pine.LNX.4.64.1003150159590.12526@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1003150159590.12526@hs20-bc2-1.build.redhat.com>
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

> Iterate both origin and snapshot devices
> 
> iterate_devices method should call the callback for all the devices where
> the bio may be remapped. Thus, snapshot_iterate_devices should call the callback
> for both snapshot and origin underlying devices because it remaps some bios
> to the snapshot and some to the origin.
> 
> snapshot_iterate_devices called the callback only for the origin device.
> This lead to badly calculated device limits if snapshot and origin were placed
> on different types of disks.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Reviewed-by: Mike Snitzer <snitzer@redhat.com>
