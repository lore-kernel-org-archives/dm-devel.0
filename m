From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: DM_snapshot_cow filesystem (dmsetup create snapshot)
Date: Sat, 29 Oct 2011 21:49:47 +0100
Message-ID: <20111029204947.GU23336@agk-dp.fab.redhat.com>
References: <4EABE131.8010706@googlemail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4EABE131.8010706@googlemail.com>
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
List-Id: dm-devel.ids

markmc did some code that shows how to read the format a few years ago here:
http://people.gnome.org/~markmc/code/merge-dm-snapshot.c

Otherwise look at dm-snap-persistent.c in the kernel tree.

Alasdair
