Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061904D1F96
	for <dm-devel@lists.linux.dev>; Mon, 19 Oct 2026 14:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792421063; cv=none; b=D9FN6mQ0rheC42JEpifAxuSRtJQ2kvG2oXftvtTnmsNbzSFRYkOkcuND+n/MmccTTfAE6PgRxcM/JmnYPKLf4YRAGQS/7IQxy6Gt6oiMI60IcQMAbZl1Ial+/TR4CWz0L946U/hqeO5HE6W06naSreUVvgwrUqDaaz+s93T60oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792421063; c=relaxed/simple;
	bh=9wn5LkPnBD/iUNM2geidOv03yWjpV9HNQP4bqVB+BcA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PVSLzXvM9MlAnpFVNRTAAEdStAJCUTFfvn0XJlugYGAgFwY3cA2CJh73WFMW3YdHbyyOJ7mhtixxxV0c5f54vjEKRlCLkon4qQWZaCA/0pPVk9TRIRMqf93/XqjrgpnKz4V3hHTNjv1GCUcDWAxQofGz/1pgtmVWwAJtQhdfNp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=questdb.com; spf=pass smtp.mailfrom=questdb.com; dkim=pass (2048-bit key) header.d=questdb.com header.i=@questdb.com header.b=ypx/G5WL; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=questdb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=questdb.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=questdb.com header.i=@questdb.com header.b="ypx/G5WL"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a0286c981dso23122425e9.2
        for <dm-devel@lists.linux.dev>; Mon, 19 Oct 2026 07:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=questdb.com; s=google; t=1792421059; x=1793025859; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=H5pxaVjpVO0QzVISWqhkhKMRLAE00h6htX4rk5lkRlo=;
        b=ypx/G5WLLbPl0XRkU87EgKdVwx0EU0datQCiEFEArT6oayXB7J7/A5bzV9K4tYIO7A
         uDgfO8agAgdd8b4rL3dgAGw02wI3RNLdcMteHuzNMeqMEgHVdCeMp2+U6OuvKDosMzfT
         JdgJ93dj7syD+O7raGtPC30uqJJq9n41PQrhzHDY3khh5T0SGqpbxAghU7wqCnc7AyAX
         LX4jvMr+XOcJ88DhSbtlErST3XhciayeMisTbmpnwsdCEnFst7EfUMPUaI+9J6ggD0ee
         g0BGI5xuQsbtcetBtWRVhOewxEghUZX0rHUqlZahfy4teMLFOLdByXHLRw6Ft59gPEkq
         TliA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792421059; x=1793025859;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H5pxaVjpVO0QzVISWqhkhKMRLAE00h6htX4rk5lkRlo=;
        b=OQXPU0kVq6l+xdxRjhYmPKRbBNylCXwl6e2QJzt5jEBA2OoDnUVC50LxhxSYndOpxU
         DZZS3lZROaftHpyUWzMwLHlLBc88AIo3wqjSH4yJwEgqgxmNx608kuM5rZjJ+ss5OBCZ
         n/NSglbnJpxHsLtNhnoOWjZ5qC0XnjQ0+h0z3+xDUKzatkonQyCvU6katf+XzlnjevYr
         w+3AZaS+1WiiwvMwsZy2oPJdrAgR/D/rCG93wQugeWNLAapnCeW2Mwd9nwGRCFCVOhCu
         vHbwyHhRgMKdHrCY8cFZx7CY837GgAV+QtDAkhmPL4PHW0qy9X6gk6sNkq97SJviOser
         WVAQ==
X-Gm-Message-State: AFq9FYKcne27FfhOZWEOzOtpj02petzpsnmGMYwdPmChURKtxICf8hl2
	HbeyvLZca0Jsy1Fgrv02tf0UTQxuvdOWfT+SYmk5gKrg/QDvnMFpUvNInXdydN8iiK8=
X-Gm-Gg: AYBFou3NbGUz1gF0Ws6+FUiNUheA2mACJG1IUeNEyRDa3kSCVYlRCSkpVd80bBuSDwm
	pbw7rtAP3Vwy+bLw0SvcgpQNoIq+TneTohKz6d8nFpprpxB93xvd2PZZAPLhaPtRVDzWGGhNNeZ
	dsRKVQ8BGrJhKJI9hG7yU6+pQwLha7TXNAOkZ8yTfWXTuj7sTz1qlajxMxjoDtp0riynNT3MIzv
	dxaoxsRP6yAO1xpp7jaqmq7LJU9alrgk9cTOoh+8l9Z7A2z/GgAhBhLSpCrzBM94qjW6L7yXkTV
	PZTT63WplUBDQeyX7FRGbMnbkNMKSRMmX6Sx8+TUdtpeCNSj+NRLPIgepfvcIgw8AI2k7HDWFgc
	1px3nWsfnBIiCYUm5ZSJDuwPdvGrXUIixPf7GGUUfql/pW9d//VbBiOAotDd3+PyD3Ed5xoee08
	RFHMyuNrDPJRhq8v1a9tLzk1VkWreIYkK4EGhP+uY4cOtXPSLF93oS8ieIbkQHQJHryGNhOcK/
X-Received: by 2002:a05:600c:3e17:b0:49d:34:420d with SMTP id 5b1f17b1804b1-4a1d7601e40mr169806255e9.20.1792421059042;
        Mon, 19 Oct 2026 07:44:19 -0700 (PDT)
Received: from pop-os ([145.224.123.18])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd510201sm24621143f8f.55.2026.10.19.07.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 07:44:18 -0700 (PDT)
From: Eugene Lysiuchenko <eugene@questdb.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	fstests@vger.kernel.org,
	Josef Bacik <josef@toxicpanda.com>,
	eugene@questdb.com,
	stable@vger.kernel.org
Subject: [PATCH] dm log writes: log flush batches in the order the flushes were issued
Date: Mon, 19 Oct 2026 17:43:39 +0300
Message-ID: <20261019144339.387551-1-eugene@questdb.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm-log-writes gives a flush the writes that completed before the flush
was issued, and logs that batch when the flush completes.  When two
flushes are in flight at once and the later one completes first, its
batch is logged first.  If both batches hold a write to the same
sector, the log then has the older write after the newer one:

	W1,C1,Wflush1,W1',C1',Wflush2,Cflush2,Cflush1

is logged as

	W1',flush2,W1,flush1

and a replay ends with W1, although the device held W1' from the
moment flush2 completed.

Two flushes can be in flight at once on a device with more than one
hardware queue, because each queue runs its own flush sequence.  Two
tasks that fsync at the same time can hit this.  We hit it recording
ext4 on an 8-queue virtio-blk disk: the older version of a file's data
block was in the batch of a jbd2 commit's flush, the newer version in
the batch of an empty flush issued after it, and the commit's flush
completed last.  The replayed file held a stale block that the device
never held after the empty flush completed.  On the same disk, fstests
generic/455 on xfs (four fsx processes that fsync concurrently) failed
with "md5sum mismatched" in 5 of 31 runs without this change and in 0
of 31 runs with it.

When a flush completes, every write that completed before the flush
was issued is durable.  That includes the writes held by earlier
flushes that have not completed yet.  Keep the flushes in flight in
issue order.  When a flush completes, log the batches of the earlier
flushes first, then its own.  An earlier flush still logs its own
entry when it completes; by then its batch is empty.

An AI coding assistant found the problem while investigating a false
failure in a crash-consistency test harness.  It also wrote the
reproducer and the first version of this change.

Fixes: 0e9cebe72459 ("dm: add log writes target")
Cc: stable@vger.kernel.org
Assisted-by: LLM sparse
Signed-off-by: Eugene Lysiuchenko <eugene@questdb.com>
---
Based on linux-dm for-next (dm-7.4, 334714e4bdf8).  Both files are
identical on dm-7.3 (fc79aeb86a2c) and mainline (c03c1a14507d), so the
patch applies there unchanged.

Tested in an 8-vCPU QEMU/KVM guest (Ubuntu 24.04 userspace) booted on
this tree, built from defconfig + kvm_guest.config with
DM_LOG_WRITES=y.  The virtio-blk disks have 8 hardware queues and a
write-back cache.  Stock vs patched:

- Reproducer (script below): the data device is an in-process nbd
  server with two connections, so its queue has two hardware queues.
  The server holds the first flush until a second flush, issued from a
  CPU on the other queue, has completed.  On one block: write OLD,
  fsync (held), write NEW, fsync (completes), release the first flush.
  Stock: the log reads NEW,flush,OLD,flush and replays to OLD, 20 of
  20 runs.  Patched: OLD,NEW,flush,flush and NEW, 20 of 20.

- Stress, no injected delays: 8 threads, one per CPU, each rewriting
  its own blocks with O_DIRECT write + fsync through log-writes on a
  virtio-blk disk, 20 s per run, 8 runs.  Stock: an older version of a
  block logged after a newer one in 5 of 8 runs (7 entries, 231k
  write+fsync pairs).  Patched: 0 of 8 runs (203k pairs).

- fstests generic/455, generic/457 and generic/482 pass with the patch
  on ext4, xfs and btrfs.  Without it, generic/455 on xfs fails with
  "testfileN.markM md5sum mismatched" in 5 of 31 iterations; with it,
  0 of 31.  On ext4 it passed 11 of 11 both ways.

- No kernel warnings in any run.  The WARN_ON added to the destructor
  never fired over several hundred device teardowns.

- drivers/md/dm-log-writes.o built with W=1 and with C=1 (sparse
  0.6.4): no warnings before or after.  checkpatch.pl --strict: clean.

Not done: generic/470 (needs a DAX device; "not run" here); no run on
real multi-queue hardware (only virtio-blk and nbd); no explicit
single-queue test beyond what fstests used.  The same code change,
built out of tree against Ubuntu's 6.8 kernel, gave the same
reproducer and stress results there.

Performance: fio through log-writes on the same guest, 8 jobs, 4k
random writes, O_DIRECT, psync, 5 rounds alternating between the two
kernels.  With fsync after every write, so up to 8 flushes in flight:
1235 vs 1218 IOPS, fsync latency 4.5 vs 4.6 ms mean and 13.0 ms p99 on
both.  With fsync every 64 writes: 18853 vs 18933 IOPS.  The spread
between rounds for one kernel is 4-12%, so no measurable difference.
None is expected: the patch adds one list insertion per flush at map
time and, when a flush completes, a loop over the flushes in flight,
which are at most as many as the hardware queues.

Memory: struct pending_block grows by one list_head, from 64 to 80
bytes on x86_64, next to the 4 KiB page copy it holds per segment.

An alternative design would keep every completed write in
unflushed_blocks, stamp it with the number of flushes issued so far,
and let a completing flush move the writes whose stamp is below its
own number.  That models the rule more directly and a failed flush
needs no special handling, but it replaces the batch mechanism rather
than correcting it and walks the batch on completion instead of
splicing it.  This patch keeps the existing design; switching is easy
if you prefer the other.

The stress script is available on request.

Reproducer.  Python 3, run as root in a VM; LOGDEV is overwritten.
Needs nbd and dm-log-writes, built in or as modules.

#!/usr/bin/env python3
"""
dm-log-writes: two flushes that overlap and complete out of order put an
older write after a newer write of the same sector in the log.

Stack:
    /dev/mapper/lwrepro = log-writes /dev/nbd0 LOGDEV

/dev/nbd0 is served by this script over two connections, so the nbd queue
has two hardware queues and two flushes can be in flight at once.  The
server holds the first flush until the second one has completed, which
makes the interleaving deterministic.

Sequence, all on block 0 of the data device:

    1. write "OLD"   O_DIRECT, completes           -> unflushed = [OLD]
    2. fsync #1      flush F1 issued, server holds  -> F1 takes [OLD]
    3. write "NEW"   O_DIRECT, completes           -> unflushed = [NEW]
    4. fsync #2      flush F2 issued, completes     -> F2 takes [NEW]
                     fsync #2 returns
    5. server releases F1, fsync #1 returns
    6. fsync #3      flush F3, nothing pending

The device received OLD before NEW, and both writes completed before a
flush that then completed, so the device holds NEW.  Replaying the log must
give NEW too.  dm-log-writes logs a flush's batch when that flush
completes, so it logs [NEW] at step 4 and [OLD] at step 5, and the replay
ends with OLD: a state the device never held.

Usage (as root, in a VM; LOGDEV is overwritten):
    dmlw-flush-reorder.py LOGDEV [ITERATIONS]
Exit status: 0 if the log replays to what the device holds, 1 if not.
"""
import fcntl
import mmap
import os
import socket
import struct
import subprocess
import sys
import threading
import time

NBD_SET_SOCK, NBD_SET_BLKSIZE, NBD_SET_SIZE, NBD_DO_IT = 0xAB00, 0xAB01, 0xAB02, 0xAB03
NBD_CLEAR_SOCK, NBD_DISCONNECT, NBD_SET_FLAGS = 0xAB04, 0xAB08, 0xAB0A
NBD_FLAG_HAS_FLAGS, NBD_FLAG_SEND_FLUSH, NBD_FLAG_CAN_MULTI_CONN = 1 << 0, 1 << 2, 1 << 8
NBD_REQUEST_MAGIC, NBD_REPLY_MAGIC = 0x25609513, 0x67446698
NBD_CMD_READ, NBD_CMD_WRITE, NBD_CMD_DISC, NBD_CMD_FLUSH = 0, 1, 2, 3
BLKFLSBUF = 0x1261

LOG_FLUSH, LOG_FUA, LOG_DISCARD, LOG_MARK, LOG_META = 1, 2, 4, 8, 16
WRITE_LOG_MAGIC = 0x6A736677736872

NBD = "nbd0"
DM = "lwrepro"
BS = 4096
SIZE = 64 << 20
OLD, NEW = b"OLD!" * (BS // 4), b"NEW!" * (BS // 4)


def recvall(s, n):
    buf = bytearray()
    while len(buf) < n:
        chunk = s.recv(n - len(buf))
        if not chunk:
            return None
        buf += chunk
    return bytes(buf)


class Server:
    """An in-memory nbd server. `store` is what the device holds once every
    flush has completed."""

    def __init__(self, nconn):
        self.store = bytearray(SIZE)
        self.lock = threading.Lock()
        self.pairs = [socket.socketpair() for _ in range(nconn)]
        self.send_locks = [threading.Lock() for _ in range(nconn)]
        self.hold_next_flush = False
        self.held = None
        self.held_event = threading.Event()
        self.threads = [threading.Thread(target=self.serve, args=(i,), daemon=True)
                        for i in range(nconn)]
        for t in self.threads:
            t.start()

    def reply(self, i, handle, data=b""):
        with self.send_locks[i]:
            self.pairs[i][1].sendall(struct.pack(">II8s", NBD_REPLY_MAGIC, 0, handle) + data)

    def serve(self, i):
        s = self.pairs[i][1]
        while True:
            hdr = recvall(s, 28)
            if hdr is None:
                return
            magic, typ, handle, off, ln = struct.unpack(">II8sQI", hdr)
            assert magic == NBD_REQUEST_MAGIC, hex(magic)
            cmd = typ & 0xFFFF
            if cmd == NBD_CMD_WRITE:
                data = recvall(s, ln)
                with self.lock:
                    self.store[off:off + ln] = data
                self.reply(i, handle)
            elif cmd == NBD_CMD_READ:
                with self.lock:
                    data = bytes(self.store[off:off + ln])
                self.reply(i, handle, data)
            elif cmd == NBD_CMD_FLUSH:
                with self.lock:
                    hold, self.hold_next_flush = self.hold_next_flush, False
                    if hold:
                        self.held = (i, handle)
                if hold:
                    self.held_event.set()  # answered later by release()
                else:
                    self.reply(i, handle)
            elif cmd == NBD_CMD_DISC:
                return
            else:
                self.reply(i, handle)

    def release(self):
        i, handle = self.held
        self.held = None
        self.reply(i, handle)


def sh(cmd, **kw):
    return subprocess.run(cmd, shell=True, check=True, text=True, capture_output=True, **kw).stdout


def cpu_list(q):
    with open(f"/sys/block/{NBD}/mq/{q}/cpu_list") as f:
        return [int(c) for c in f.read().replace(",", " ").split()]


def on_cpu(cpu, fn):
    """Run fn in a new thread pinned to cpu. Returns (thread, result dict)."""
    res = {}

    def run():
        os.sched_setaffinity(0, {cpu})
        try:
            res["value"] = fn()
        except BaseException as e:  # noqa: BLE001 - reported by the caller
            res["error"] = e

    t = threading.Thread(target=run, daemon=True)
    t.start()
    return t, res


def nbd_connect(srv):
    fd = os.open(f"/dev/{NBD}", os.O_RDWR)
    fcntl.ioctl(fd, NBD_CLEAR_SOCK)
    fcntl.ioctl(fd, NBD_SET_BLKSIZE, BS)
    fcntl.ioctl(fd, NBD_SET_SIZE, SIZE)
    fcntl.ioctl(fd, NBD_SET_FLAGS, NBD_FLAG_HAS_FLAGS | NBD_FLAG_SEND_FLUSH | NBD_FLAG_CAN_MULTI_CONN)
    for kernel_end, _ in srv.pairs:
        fcntl.ioctl(fd, NBD_SET_SOCK, kernel_end.fileno())
    doit = threading.Thread(target=lambda: fcntl.ioctl(fd, NBD_DO_IT), daemon=True)
    doit.start()
    for _ in range(200):
        if os.path.exists(f"/sys/block/{NBD}/pid"):
            return fd, doit
        time.sleep(0.01)
    raise RuntimeError("nbd device never started")


def nbd_disconnect(fd, doit):
    fcntl.ioctl(fd, NBD_DISCONNECT)
    doit.join(10)
    fcntl.ioctl(fd, NBD_CLEAR_SOCK)
    os.close(fd)


def read_log(logdev):
    fd = os.open(logdev, os.O_RDONLY)
    try:
        fcntl.ioctl(fd, BLKFLSBUF, 0)
        magic, version, nr, ss = struct.unpack("<QQQI", os.pread(fd, 28, 0))
        assert magic == WRITE_LOG_MAGIC, f"no dm-log-writes super on {logdev}"
        off, entries = ss, []
        for i in range(nr):
            hdr = os.pread(fd, ss, off)
            sector, nsec, flags, dlen = struct.unpack("<QQQQ", hdr[:32])
            mark = hdr[32:32 + dlen].decode() if flags & LOG_MARK else ""
            data = b""
            if nsec and not flags & (LOG_DISCARD | LOG_MARK):
                data = os.pread(fd, nsec * ss, off + ss)
            entries.append((i, sector, nsec, flags, mark, data))
            off += ss * (1 + (0 if flags & LOG_DISCARD else nsec))
        return ss, entries
    finally:
        os.close(fd)


def module_version(name):
    try:
        with open(f"/sys/module/{name}/srcversion") as f:
            return "srcversion " + f.read().strip()
    except FileNotFoundError:
        return "built-in"


def tag(block):
    return {OLD[:4]: "OLD", NEW[:4]: "NEW", bytes(4): "zero"}.get(bytes(block[:4]), block[:4].hex())


def describe(flags):
    names = [n for b, n in ((LOG_FLUSH, "FLUSH"), (LOG_FUA, "FUA"), (LOG_DISCARD, "DISCARD"),
                            (LOG_MARK, "MARK"), (LOG_META, "META")) if flags & b]
    return ",".join(names) or "WRITE"


def run_once(logdev, verbose):
    sh(f"dd if=/dev/zero of={logdev} bs=1M count=16 oflag=direct status=none")
    srv = Server(2)
    nbd_fd, doit = nbd_connect(srv)
    dm_up = False
    try:
        q0, q1 = cpu_list(0), cpu_list(1)
        wc = open(f"/sys/block/{NBD}/queue/write_cache").read().strip()
        assert wc == "write back", f"{NBD} write_cache is '{wc}': flushes would never reach the device"
        sh(f"echo '0 {SIZE // 512} log-writes /dev/{NBD} {logdev}' | dmsetup create {DM}")
        dm_up = True
        sh("udevadm settle")
        c0, c1 = q0[0], q1[0]
        os.sched_setaffinity(0, {c1})
        fd = os.open(f"/dev/mapper/{DM}", os.O_RDWR | os.O_DIRECT)
        buf = mmap.mmap(-1, BS)

        def write(content):
            buf.seek(0)
            buf.write(content)
            assert os.pwrite(fd, buf, 0) == BS

        write(OLD)                                            # 1
        srv.hold_next_flush = True
        t1, r1 = on_cpu(c0, lambda: os.fsync(fd))             # 2
        if not srv.held_event.wait(5):
            raise RuntimeError("flush F1 never reached the server")
        write(NEW)                                            # 3
        t2, r2 = on_cpu(c1, lambda: os.fsync(fd))             # 4
        t2.join(5)
        if t2.is_alive():
            srv.release()
            raise RuntimeError("fsync #2 did not complete while F1 was held: the two flushes "
                               f"were serialized (cpu {c0} and cpu {c1} on one queue?)")
        sh(f"dmsetup message {DM} 0 mark fsync2-returned")
        srv.release()                                         # 5
        t1.join(5)
        assert not t1.is_alive() and "error" not in r1 and "error" not in r2, (r1, r2)
        os.fsync(fd)                                          # 6
        sh(f"dmsetup message {DM} 0 mark all-flushed")
        os.close(fd)
        sh(f"udevadm settle; dmsetup remove --retry {DM}")
        dm_up = False
    finally:
        if dm_up:
            subprocess.run(f"udevadm settle; dmsetup remove --retry {DM}", shell=True)
        nbd_disconnect(nbd_fd, doit)

    device = tag(srv.store[:BS])
    ss, entries = read_log(logdev)
    replay = {}
    rows = []
    for i, sector, nsec, flags, mark, data in entries:
        if data:
            for k in range(nsec):
                replay[sector + k] = data[k * ss:(k + 1) * ss]
        what = f"block {sector}  {tag(data)}" if data else mark
        rows.append(f"  #{i:<2} {describe(flags):<6} {what:<24} replay -> block 0 = "
                    f"{tag(replay.get(0, bytes(BS)))}")
    replayed = tag(replay.get(0, bytes(BS)))
    if verbose:
        print(f"nbd queues: q0 cpus {q0}, q1 cpus {q1}; F1 issued on cpu {c0}, F2 on cpu {c1}")
        print(f"kernel {os.uname().release}, dm-log-writes {module_version('dm_log_writes')}")
        print("log, in the order dm-log-writes recorded it:")
        print("\n".join(rows))
        print(f"device block 0, all flushes completed: {device}")
        print(f"log replayed to the end, block 0:      {replayed}")
    return device, replayed


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    logdev, n = sys.argv[1], int(sys.argv[2]) if len(sys.argv) > 2 else 1
    # Fails harmlessly when nbd and dm-log-writes are built in; with built-in nbd
    # boot with nbd.max_part=0.
    subprocess.run("modprobe nbd nbds_max=4 max_part=0; modprobe dm-log-writes",
                   shell=True, capture_output=True)
    bad = 0
    for it in range(n):
        device, replayed = run_once(logdev, verbose=(it == 0))
        bad += device != replayed
    print(f"{bad} of {n} runs: log replays to {'OLD' if bad else 'the device content'}"
          f"{' while the device holds NEW -> REORDERED' if bad else ' -> consistent'}")
    sys.exit(1 if bad else 0)


if __name__ == "__main__":
    main()

 .../admin-guide/device-mapper/log-writes.rst  | 15 ++++++++++++
 drivers/md/dm-log-writes.c                    | 23 +++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/Documentation/admin-guide/device-mapper/log-writes.rst b/Documentation/admin-guide/device-mapper/log-writes.rst
index 23141f2ffb..e917a549a2 100644
--- a/Documentation/admin-guide/device-mapper/log-writes.rst
+++ b/Documentation/admin-guide/device-mapper/log-writes.rst
@@ -36,6 +36,21 @@ Again this is to simulate what is actually on disk, this allows us to detect
 cases where a power failure at a particular point in time would create an
 inconsistent file system.
 
+Two REQ_PREFLUSH requests can be in flight at the same time and complete in the
+opposite order.  The flush that completes first makes the WRITEs held by the
+earlier flush durable too, since they completed before either flush was issued,
+so those are logged first, followed by its own.  Consider the following example,
+where W1 and W1' both write the same sector:
+
+	W1,C1,Wflush1,W1',C1',Wflush2,Cflush2,Cflush1
+
+The log would show the following:
+
+	W1,W1',flush2,flush1
+
+Logging each flush's WRITEs when that flush completes would log W1 after W1',
+and a replay would end with W1, which the device never held after flush2.
+
 Any REQ_FUA requests bypass this flushing mechanism and are logged as soon as
 they complete as those requests will obviously bypass the device cache.
 
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index c72e07c3f5..473c5776b2 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -115,6 +115,7 @@ struct log_writes_c {
 	spinlock_t blocks_lock;
 	struct list_head unflushed_blocks;
 	struct list_head logging_blocks;
+	struct list_head inflight_flushes;
 	wait_queue_head_t wait;
 	struct task_struct *log_kthread;
 	struct completion super_done;
@@ -128,6 +129,7 @@ struct pending_block {
 	char *data;
 	u32 datalen;
 	struct list_head list;
+	struct list_head flush_list;
 	struct bio_vec vecs[];
 };
 
@@ -527,6 +529,7 @@ static int log_writes_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	spin_lock_init(&lc->blocks_lock);
 	INIT_LIST_HEAD(&lc->unflushed_blocks);
 	INIT_LIST_HEAD(&lc->logging_blocks);
+	INIT_LIST_HEAD(&lc->inflight_flushes);
 	init_waitqueue_head(&lc->wait);
 	init_completion(&lc->super_done);
 	atomic_set(&lc->io_blocks, 0);
@@ -629,6 +632,7 @@ static void log_writes_dtr(struct dm_target *ti)
 
 	WARN_ON(!list_empty(&lc->logging_blocks));
 	WARN_ON(!list_empty(&lc->unflushed_blocks));
+	WARN_ON(!list_empty(&lc->inflight_flushes));
 	dm_put_device(ti, lc->dev);
 	dm_put_device(ti, lc->logdev);
 	kfree(lc);
@@ -689,6 +693,7 @@ static int log_writes_map(struct dm_target *ti, struct bio *bio)
 		return DM_MAPIO_KILL;
 	}
 	INIT_LIST_HEAD(&block->list);
+	INIT_LIST_HEAD(&block->flush_list);
 	pb->block = block;
 	atomic_inc(&lc->pending_blocks);
 
@@ -717,6 +722,7 @@ static int log_writes_map(struct dm_target *ti, struct bio *bio)
 	if (flush_bio && !bio_sectors(bio)) {
 		spin_lock_irq(&lc->blocks_lock);
 		list_splice_init(&lc->unflushed_blocks, &block->list);
+		list_add_tail(&block->flush_list, &lc->inflight_flushes);
 		spin_unlock_irq(&lc->blocks_lock);
 		goto map_bio;
 	}
@@ -757,6 +763,7 @@ static int log_writes_map(struct dm_target *ti, struct bio *bio)
 	if (flush_bio) {
 		spin_lock_irq(&lc->blocks_lock);
 		list_splice_init(&lc->unflushed_blocks, &block->list);
+		list_add_tail(&block->flush_list, &lc->inflight_flushes);
 		spin_unlock_irq(&lc->blocks_lock);
 	}
 map_bio:
@@ -776,6 +783,22 @@ static int normal_end_io(struct dm_target *ti, struct bio *bio,
 
 		spin_lock_irqsave(&lc->blocks_lock, flags);
 		if (block->flags & LOG_FLUSH_FLAG) {
+			struct pending_block *prev;
+
+			/*
+			 * This flush made every write that completed before it
+			 * was issued durable, including the writes held by
+			 * flushes issued earlier that have not completed yet.
+			 * Log those first, in the order their flushes were
+			 * issued, so that a write is never logged after a newer
+			 * write to the same sector.
+			 */
+			list_for_each_entry(prev, &lc->inflight_flushes, flush_list) {
+				if (prev == block)
+					break;
+				list_splice_tail_init(&prev->list, &lc->logging_blocks);
+			}
+			list_del_init(&block->flush_list);
 			list_splice_tail_init(&block->list, &lc->logging_blocks);
 			list_add_tail(&block->list, &lc->logging_blocks);
 			wake_up_process(lc->log_kthread);

base-commit: 334714e4bdf8868c17a7650a7502ba1c90a8721f
-- 
2.53.0

