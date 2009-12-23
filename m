From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Topology fixes
Date: Wed, 23 Dec 2009 15:31:28 -0500
Message-ID: <1261600290-29627-1-git-send-email-martin.petersen@oracle.com>
References: <20091223171351.GA17896@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091223171351.GA17896@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, snitzer@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

These two patches fix several block I/O topology stacking issues.

The first patch corrects an error in calculating partition
offsets.  It should go into stable as well as .33.

The second patch is a revamp of the stacking algorithm for both
data and discard. 2.6.33 only.

--
Martin K. Petersen      Oracle Linux Engineering
