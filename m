From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm-kcopyd/dm-snap: Don't read the origin on
 full chunk write
Date: Fri, 24 Jun 2011 08:35:38 +0100
Message-ID: <20110624073537.GB2888@ubuntu>
References: <Pine.LNX.4.64.1106232021200.12675@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1106232021200.12675@hs20-bc2-1.build.redhat.com>
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
Cc: "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Jun 23, 2011 at 08:25:44PM -0400, Mikulas Patocka wrote:
> Hi
> 
> This is the new patch for optimizing full chunk write. dm-kcopyd provides 
> only callbacks.

I'm happy with this approach, you keep bios out of the interface.

- Joe
