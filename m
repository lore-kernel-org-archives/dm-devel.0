Received: from mail.189.cn (189sx01-ptr.21cn.com [125.88.204.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5990F37E30D
	for <dm-devel@lists.linux.dev>; Mon, 13 Apr 2026 08:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=125.88.204.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776067312; cv=none; b=RQg9uMZ4ngEpAAj/1olcVKlpsBd7VLV6vq6fVpmih/I1kbAZ+V7yQvM0vXb3KxEON8nFvYstWkUqnaS/TM2oKHlQATCIqUpKCR2O3dSWQfskAFrg9cWecyqiOWFdKYWIZLRS5Mnn+Q8nrIcn3fxwZ/BZJxwaHaA4t/1ZXp3vu74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776067312; c=relaxed/simple;
	bh=VUnQLH2pPEqvFRZdcj9hGaqbHbCCyp43cVorRQ4b3rQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tRPF67TfubqhH/7s/1mip48Yz6AGV2Gj/QV5k15ec8wXcTH+X6Uk2ubXdFjbYnnoMYjH5AQvJRdJQlXJ56ZUCzxRHmg4tphn5vLo9gfIGYkeEeXJmua7rz/u4L1PNBOt8kzhXHW42MiSblFldw2j4ZqxWmUsffECrKXEgEzDY/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=189.cn; spf=pass smtp.mailfrom=189.cn; arc=none smtp.client-ip=125.88.204.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=189.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=189.cn
HMM_SOURCE_IP:10.158.242.145:0.2069108682
HMM_ATTACHE_NUM:0000
HMM_SOURCE_TYPE:SMTP
Received: from clientip-221.238.56.48 (unknown [10.158.242.145])
	by mail.189.cn (HERMES) with SMTP id 24E5F4002A1;
	Mon, 13 Apr 2026 16:01:43 +0800 (CST)
Received: from  ([221.238.56.48])
	by gateway-153622-dep-76cc7bc9cd-r45x9 with ESMTP id 33ade6dc9ca54545a389407f17f1d0f0 for rafael@kernel.org;
	Mon, 13 Apr 2026 16:01:46 CST
X-Transaction-ID: 33ade6dc9ca54545a389407f17f1d0f0
X-Real-From: chensong_2000@189.cn
X-Receive-IP: 221.238.56.48
X-MEDUSA-Status: 0
Sender: chensong_2000@189.cn
From: chensong_2000@189.cn
To: rafael@kernel.org,
	lenb@kernel.org,
	mturquette@baylibre.com,
	sboyd@kernel.org,
	viresh.kumar@linaro.org,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	song@kernel.org,
	yukuai@fnnas.com,
	linan122@huawei.com,
	jason.wessel@windriver.com,
	danielt@kernel.org,
	dianders@chromium.org,
	horms@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	paulmck@kernel.org,
	frederic@kernel.org,
	mcgrof@kernel.org,
	petr.pavlu@suse.com,
	da.gomez@kernel.org,
	samitolvanen@google.com,
	atomlin@atomlin.com,
	jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mark.rutland@arm.com,
	mathieu.desnoyers@efficios.com
Cc: linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-clk@vger.kernel.org,
	linux-pm@vger.kernel.org,
	live-patching@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	kgdb-bugreport@lists.sourceforge.net,
	netdev@vger.kernel.org,
	Song Chen <chensong_2000@189.cn>
Subject: [RFC PATCH 0/2] Decouple ftrace/livepatch from module loader via notifier priority and reverse traversal
Date: Mon, 13 Apr 2026 16:01:40 +0800
Message-ID: <20260413080140.180616-1-chensong_2000@189.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Song Chen <chensong_2000@189.cn>

This patchset addresses a long-standing tight coupling between the
module loader and two of its key consumers: ftrace and livepatch.

Background:

The module loader currently hard-codes direct calls to
ftrace_module_enable(), klp_module_coming(), klp_module_going() and
ftrace_release_mod() inside prepare_coming_module() and the module
unload path. This hard-coding was necessary because the module notifier
chain could not guarantee the strict call ordering that ftrace and
livepatch require:

  During MODULE_STATE_COMING, ftrace must run before livepatch, so
  that per-module function records are ready before livepatch registers
  its ftrace hooks.

  During MODULE_STATE_GOING, livepatch must run before ftrace, so that
  livepatch removes its hooks before ftrace releases those records.

This symmetric setup/teardown ordering could not be expressed through
the notifier chain because the chain only supported forward (descending
priority) traversal. Without reverse traversal, it was impossible to
guarantee that the GOING order would be the strict inverse of the
COMING order using a single priority value per notifier.

Patch 1 - notifier: replace single-linked list with double-linked list.
Patch 2 - ftrace/klp: decouple from module loader using notifier
priority.

headsup: somehow the smtp of my mailbox doesn't work very well lately, 
if i receive return letter, i have to resend, sorry in advance.

Song Chen (2):
  kernel/notifier: replace single-linked list with double-linked list
    for reverse traversal
  kernel/module: Decouple klp and ftrace from load_module

 drivers/acpi/sleep.c      |   1 -
 drivers/clk/clk.c         |   2 +-
 drivers/cpufreq/cpufreq.c |   2 +-
 drivers/md/dm-integrity.c |   1 -
 drivers/md/md.c           |   1 -
 include/linux/module.h    |   8 ++
 include/linux/notifier.h  |  26 ++---
 kernel/debug/debug_core.c |   1 -
 kernel/livepatch/core.c   |  29 ++++-
 kernel/module/main.c      |  34 +++---
 kernel/notifier.c         | 219 ++++++++++++++++++++++++++++++++------
 kernel/trace/ftrace.c     |  38 +++++++
 net/ipv4/nexthop.c        |   2 +-
 13 files changed, 290 insertions(+), 74 deletions(-)

-- 
2.43.0

