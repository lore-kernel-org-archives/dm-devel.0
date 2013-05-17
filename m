From: Karthi <karthikeyani.palanisami@gmail.com>
Subject: Reg. Persistent Metadata API
Date: Fri, 17 May 2013 12:36:03 -0400
Message-ID: <CANPE0nUeTkLYTU3vDCdvKhF_zm0Kb0K9YKPrcM+7qHJ7Yhuwfw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2518810980269814065=="
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: Vasily Tarasov <tarasov@vasily.name>, Erez Zadok <ezk@cs.stonybrook.edu>
List-Id: dm-devel.ids

--===============2518810980269814065==
Content-Type: multipart/alternative; boundary=001a11c3c3485ee6f704dcec955b

--001a11c3c3485ee6f704dcec955b
Content-Type: text/plain; charset=UTF-8

Hi everyone,

Our group works on a device mapper target called dmDedup that performs
inline data deduplication. The dmDedup target internally uses the
Persistent Metadata API (located in linux/drivers/md/persistent-data)to
manage its meta-data.

In our system, there is a main writer thread (or several of them) and a
separate flusher thread. When a write request comes in, the writer thread
checks for the duplicates in the data and updates corresponding meta-data.
The flusher thread periodically (10 sec) flushes the meta-data to disk by
calling the commit function in the transaction manager of Persistant
Metadata API.

When we benchmark dmDedup target with a sequential unique data write
workload, we observed that write performance periodically drops to 0
ops/sec for 8 to 15 seconds. It happens because the flusher thread blocks
the writer thread. Our further analysis showed that, the writer thread is
blocked on the dm_bufio mutex lock, which is acquired by the flusher thread
on the dm_bufio_client  when the dirty buffers are being flushed as a part
of transaction. Though these dirty buffers are flushed asynchronously, the
function enters a loop with the lock acquired and exits only when it places
the request for all the dirty buffers. (drivers/md/dm-bufio.c -
dm_bufio_write_dirty_buffers()). The writer thread is blocked as it needs
this lock to lookup the metadata. The underlying I/O queue size is 128. The
flusher thread waits to place IO request for all dirty buffers (which is
much greater than 128) onto the queue. This way the writes becomes
synchronous during this entire period, thus blocking the other writer
thread.

We want a metadata flush which is not affected by the writer thread so
drastically. Specifically, we would like the flush to write out dirty
buffers, while the writer still can update metadata (using COW to preserve
consistency). Is it something that is possible with a current design of
persistent metadata subsystem? Our current understanding is that during the
commit all updates to the meta-data are blocked until all of the meta-data
is written out.

We appreciate any suggestions!

Thank you!

--001a11c3c3485ee6f704dcec955b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi everyone,<br>
<br>
Our group works on a device mapper target called dmDedup that performs
inline data deduplication. The dmDedup target internally uses the Persisten=
t Metadata API (located in linux/drivers/md/persistent-data)to manage its m=
eta-data.<br><div>
<br>
In our system, there is a main writer thread (or several of them) and a sep=
arate flusher thread. When a write request comes in, the writer
thread checks for the duplicates in the data and updates corresponding
meta-data. The flusher thread periodically (10 sec) flushes the meta-data t=
o disk by calling the commit function in the transaction manager of Persist=
ant Metadata API.<br><div>
<br>
</div>When we benchmark dmDedup target with a sequential unique data write =
workload, we observed that write performance periodically drops to 0
ops/sec for 8 to 15 seconds. It happens because the flusher thread
blocks the writer thread. Our further analysis showed that, the writer thre=
ad is blocked on the dm_bufio mutex lock, which is acquired by the flusher =
thread on the dm_bufio_client =C2=A0when the dirty buffers are being flushe=
d as a part of transaction. Though these dirty buffers are flushed asynchro=
nously, the function enters a loop with the lock acquired and exits only wh=
en it places the request for all the dirty buffers. (drivers/md/dm-bufio.c =
- dm_bufio_write_dirty_buffers()). The writer thread is blocked as it needs=
 this lock to lookup the metadata. The underlying I/O queue size is 128. Th=
e flusher thread waits to place IO request for all dirty buffers (which is =
much greater than 128) onto the queue. This way the writes becomes synchron=
ous during this entire period, thus blocking the other writer thread.<br>


<br>We want a metadata flush which is not affected by the writer thread so =
drastically. Specifically, we would like the flush to write out dirty
buffers, while the writer still can update metadata (using COW to preserve
consistency). Is it something that is possible with a current design of per=
sistent metadata subsystem? Our current understanding is that
during the commit all updates to the meta-data are blocked until all
of the meta-data is written out.<br>
<br>
We appreciate any suggestions!<br>
<br>
Thank you!</div>

--001a11c3c3485ee6f704dcec955b--


--===============2518810980269814065==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2518810980269814065==--
