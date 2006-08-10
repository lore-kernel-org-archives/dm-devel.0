From: "Haripriya S" <SHARIPRIYA@novell.com>
Subject: snapshot scalability
Date: Thu, 10 Aug 2006 04:46:29 -0600
Message-ID: <44DB5C21.F25D.00B6.0@novell.com>
References: <44DA246B020000B60000BD22@lucius.provo.novell.com>
	<44DB5BDD020000B60000BD96@lucius.provo.novell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

A co-worker recently did some tests on DM snapshots using bonnie, and
here is a rough summary of what he got as write throughput:

No Snapshots     - 373 MB/s
One Snapshots   - 55 MB/s
Two Snapshots  - 16 MB/s
Four Snapshots  - 14 MB/s
Eight Snapshots  - 6.5 MB/s

He is doing some more tests now to verify these results, but I wanted
to quickly check with the dm snapshot community. Are there any current
known scalability limits on snapshots and do the numbers mentioned here
look normal ?

Thanks and Regards,
Haripriya
