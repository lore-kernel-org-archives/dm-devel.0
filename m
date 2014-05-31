From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm linear: disable WRITE SAME if it fails
Date: Sat, 31 May 2014 15:43:38 +0100
Message-ID: <20140531144338.GI29705@agk-dp.fab.redhat.com>
References: <53042F91.4050201@huawei.com> <53899812.50403@huawei.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <53899812.50403@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: alex chen <alex.chen@huawei.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Mike Anderson <andmike@linux.vnet.ibm.com>, Mike Snitzer <snitzer@redhat.com>, Milan Broz <asi@seznam.cz>, Joseph Qi <joseph.qi@huawei.com>, christophe varoqui <christophe.varoqui@free.fr>, dm-devel@redhat.com, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Sat, May 31, 2014 at 04:51:30PM +0800, alex chen wrote:
> this patch adds DM linear end_io method 

No.  If linear needs to hook end_io something has gone seriously wrong.
Find the underlying source of the problem and fix that instead.

Alasdair
