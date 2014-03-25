From: Christoph Hellwig <hch@infradead.org>
Subject: best way to detect a dm device is dm-multipath from
	userspace?
Date: Tue, 25 Mar 2014 10:20:22 -0700
Message-ID: <20140325172022.GA32702@infradead.org>
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

For a little project I'm working on I'd like to find out if a given
device node is a dm-multipath device from C code.  dm_is_dm_major tells
me if it's any DM node, but from there on it seems like I'd have to
grab the table name from dmsetup table output for which I'd need a name
for the device or similar.

Is there a good shortcut or library function for this check?
