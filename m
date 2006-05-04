From: Guido Guenther <agx@sigxcpu.org>
Subject: Multipath on STK OPENStorage D240
Date: Thu, 4 May 2006 09:41:20 +0200
Message-ID: <20060504074119.GB17730@bogon.ms20.nix>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hi,
when using path_checker readsector0 on the above machine the box stalls
every 5 seconds when checking the currently nonactive path. Same for
path_checker tur. Is there a way to avoid this? I'd consider writing a
specific checker but am lacking any documentation.
Cheers,
 -- Guido
