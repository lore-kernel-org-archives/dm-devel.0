From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v6 0/2] dax, dm: stop requiring dax for device-mapper
Date: Wed, 29 Nov 2017 10:59:55 -0800
Message-ID: <151198199487.7051.7083189934624068090.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Gerald Schaefer <gerald.schaefer-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

Changes since v5 [1]:
* Make DAX_DRIVER select DAX to simplify the Kconfig dependencies
  (Michael)
* Rebase on 4.15-rc1 and add new IS_ENABLED(CONFIG_DAX_DRIVER) checks in
  drivers/md/dm-log-writes.c.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-September/012569.html

---

Hi Mike,

Bart points out that the DAX core is unconditionally enabled if
device-mapper is enabled. Add some config machinery and some
stub/static-inline routines to allow dax infrastructure to be deleted
from device-mapper at compile time.

---

Dan Williams (2):
      dax: introduce CONFIG_DAX_DRIVER
      dm: allow device-mapper to operate without dax support


 arch/powerpc/platforms/Kconfig |    2 -
 drivers/dax/Kconfig            |    5 ++
 drivers/md/Kconfig             |    1 
 drivers/md/dm-linear.c         |    6 +++
 drivers/md/dm-log-writes.c     |   95 +++++++++++++++++++++-------------------
 drivers/md/dm-stripe.c         |    6 +++
 drivers/md/dm.c                |   10 +++-
 drivers/nvdimm/Kconfig         |    2 -
 drivers/s390/block/Kconfig     |    2 -
 include/linux/dax.h            |   30 ++++++++++---
 10 files changed, 99 insertions(+), 60 deletions(-)
