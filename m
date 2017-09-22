From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v5 0/2] dax, dm: stop requiring dax for device-mapper
Date: Fri, 22 Sep 2017 09:25:00 -0700
Message-ID: <150609750020.25862.11458070207401120153.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Gerald Schaefer <gerald.schaefer-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids


Changes since v4:
* redo a botched send of v3
* rebase on 4.14-rc1
* rewrite the changelog of patch2 to drop broken references to the
  "built-in portion of device-mapper" (Mike)

---

Bart points out that the DAX core is unconditionally enabled if
device-mapper is enabled. Add some config machinery and stub routines to
allow device-mapper to build and run with CONFIG_DAX=n.

---

Dan Williams (2):
      dax: introduce CONFIG_DAX_DRIVER
      dm: allow device-mapper to operate without dax support


 arch/powerpc/platforms/Kconfig |    1 +
 drivers/block/Kconfig          |    1 +
 drivers/dax/Kconfig            |    4 +++-
 drivers/md/Kconfig             |    2 +-
 drivers/md/dm-linear.c         |    6 ++++++
 drivers/md/dm-stripe.c         |    6 ++++++
 drivers/md/dm.c                |   10 ++++++----
 drivers/nvdimm/Kconfig         |    1 +
 drivers/s390/block/Kconfig     |    1 +
 include/linux/dax.h            |   30 ++++++++++++++++++++++++------
 10 files changed, 50 insertions(+), 12 deletions(-)
