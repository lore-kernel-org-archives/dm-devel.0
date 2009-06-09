From: Mikulas Patocka <mpatocka@redhat.com>
Subject: snapshot interface: messages-vs-table arguments
Date: Tue, 9 Jun 2009 02:00:04 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0906090124580.1421@hs20-bc2-1.build.redhat.com>
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

These are my comments about the interface between snapshots.

Alasdair's idea is that everything is done with table loads, that messages 
are not needed (they may be used to avoid table reload, but the thing 
should work without messages). Userspace lvm will submit a list of 
snapshot IDs in the table arguments --- if the kernel has some snapshot ID 
in its store that is not listed in the table, it deletes these snapshots. 
If there are some new snapshot IDs, the kernel creates them.

Basically, the whole interface communicates just states (not commands), 
and the actions to be performed are inferred from the difference in the 
states.

I though about it, I think it would work if there were only snapshot 
creations and snapshot deletions. But it would have problems with 
snapshots-of-snapshots or with merging.

- snapshots-of-snapshots

If we create snapshot of snapshot, both the snapshots will be basically 
independent. The relationship between both snapshots exists only in the 
time when they are created, once created, they are seen as independent by 
the user (currently there is limitation that you can't create 
snapshot-of-snapshot-of-snapshot, but it will be likely relaxed when new 
disk format will be developed). The user can delete either of the 
snapshots.

If we go with "everything-is-states, there are no messages" approach, we 
have no way to represent snapshots-of-snapshots. Because both the 
snapshots are independent, there will no relationship between them in the 
metadata --- they will be just two snapshots with different IDs.

Now, how to find out that snapshot-of-snapshot was created?

Suppose that the old metadata contain origin, snap1 and snap2.

New metadata contains origin, snap1, snap2 and snap3.

The qustion is: how could a kernel find out how to create snap3? Was snap3 
new snapshot of the origin? Was it clone of snap2? Was it clone of snap1? 
We can't tell. In either of these cases, the metadata is the same!

We could store the originating snapshot for snap3, for example store into 
metadata that snap3 is the clone of snap2. But if snap2 is deleted, we 
have problem with reference pointing nowhere.


What I'm arguing is that the action to be performed (make new snapshot-vs 
clone existing snapshot) cannot be inferred from the difference in the 
metadata. Therefore, we need messages or something like messages to tell 
the kernel the action.

- merge

The same situation happens with merge. From user's point of view, merge is 
similar to delete. The merged snapshot immediatelly disappears and the 
origin will contain the content of the merged snapshot. We don't need a 
background userspace process for merging (unlike merging non-shared 
snapshot where it is needed), the merging will be performed by the kernel 
on its own and space in the shared store will be progressively deleted as 
the merge goes on.

So, from userspace metadata point of view, merge is just like delete, when 
merge is initiated, the snapshot will disappear from the metadata and 
from "lvs" command output. And we have the same problem.

Old state: origin, snap1, snap2
New state: origin, snap1

--- the kernel knows that it must delete snap2. The question: should it 
delete it or should it start merging it? Again: we need the message to 
distinguish these two actions, the difference cannot be told from 
metadata.


Therefore, I think that messages are not that hacky at all, they are 
needed to tell the information that cannot be inferred from the state 
stored in the metadata. (well, one could send the "message" on the table 
argument line, but that is just worse than using message function 
directly, the table argument line was meant to specify the state of the 
target, not to send commands).

Messages can be later changed, it would be viable if we could merge 
message and status into one function --- so that target accepts string as 
a message and returns another string as status --- so that we wouldn't 
have to return last-created snapshot id in the status. But I think we 
cannot live without messages at all.

If you have some other idea how to resolve above issues, write it.

Mikulas
