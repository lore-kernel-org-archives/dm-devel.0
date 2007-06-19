From: malahal@us.ibm.com
Subject: how do I re-synchronize with the Master mirror device?
Date: Mon, 18 Jun 2007 17:14:10 -0700
Message-ID: <20070619001410.GA4442@us.ibm.com>
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

I have a dm-mirror setup where the mirror devices could occasionally
timeout due to network congestion or recovery at the device. If a device
times out, it goes out of sync with the Master. How do I sync it back?
Only few regions would have gone out of sync with the Master. Is it
possible to sync only the regions that have gone out of sync?

Thank you for your time.

--Malahal.
