From: Kristina Clair <kclair@gmail.com>
Subject: lvremove locked up
Date: Mon, 28 Feb 2005 12:50:48 -0500
Message-ID: <dff3752705022809504cadf1fc@mail.gmail.com>
References: <dff3752705022809087fe560f3@mail.gmail.com>
Reply-To: Kristina Clair <kclair@gmail.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <dff3752705022809087fe560f3@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: LVM general discussion and development <linux-lvm@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi All,

Today I had a first:  I was using lvremove to remove a snapshot, and
lvremove locked up trying to suspend the filesystem.  Between the time
when I made the snapshot and when I ran lvremove, we copied about 87G
of data over to the drive.  Is it possible that that was just too much
change for snapshots to deal with?

Mostly what I'm concerned about is that we were using snapshots
successfully up to this point, albeit conservatively.   Should I
consider this a fluke due to this one-time addition of so much data,
or should I expect this to happen again now that the volume has so
much data on it?

Thanks,
Kristina
