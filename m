From: Joe Thornber <thornber@redhat.com>
Subject: Interface changes to multisnap
Date: Mon, 20 Jun 2011 13:22:57 +0100
Message-ID: <20110620122256.GA15181@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

I've just pushed an interface change for multisnap.

From now on the 'new-thin' message to the pool target takes just one
argument, the id of the new device.  The size field has been dropped,
instead the new device has a zero size.

When a multisnap target is loaded it implicitly resizes the thin
device based on the size of the target.  Truncation will lose data
that is off the end of the new device immediately.

- Joe

https://github.com/jthornber/linux-2.6/tree/multisnap
