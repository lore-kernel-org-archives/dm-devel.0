From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: PATCH for dm-raid1 barriers
Date: Tue, 10 Nov 2009 12:18:00 +0000
Message-ID: <20091110121800.GH17055@agk-dp.fab.redhat.com>
References: <Pine.LNX.4.64.0911091420590.18408@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911091420590.18408@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Nov 09, 2009 at 02:22:14PM -0500, Mikulas Patocka wrote:
> This is that patch for bio code that is needed for dm-raid1 barriers.

Marking this superceded as we've discussed a way to get rid of
the existing hack that (ab)uses an extra bi_io_vec.

Alasdair
