From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 0/14] barriers
Date: Mon, 23 Feb 2009 14:18:56 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902231411200.23293@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi

This is the series of 14 patches for barriers. This is the "correct" 
implementation --- i.e. enabling barriers for any targets.

These patches address the upper layer only (providing barriers to 
filesystem), they don't send barrier request (there will be more patches 
for that, but they are not yet finalized).

The patches are sorted from the simples to the more complicated.

The first 11 patches shouldn't have effect on anything, they just move 
code around. So you can start slowly applying them.

Patch 11 changes generic block layer code, other patches change only dm.

Mikulas
