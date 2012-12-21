From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: How to force a snapshot status to valid when I
	know	very well it's valid?
Date: Fri, 21 Dec 2012 23:13:11 +0000
Message-ID: <20121221231311.GD14851@agk-dp.fab.redhat.com>
References: <CAM-w4HM0-Cov_KtRE410etrh+v795tsPX1UM9WkV-o4MXaQBAQ@mail.gmail.com>
	<CAEcBt+UtiFrBw778r85JfZi7FegEgO6nXxkyoAUPRGXnvFXhmQ@mail.gmail.com>
	<CAM-w4HPxTMGQd76C_Dqt56vQ1WFA7KrG4o3fbQWU1x5y=XHm5Q@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAM-w4HPxTMGQd76C_Dqt56vQ1WFA7KrG4o3fbQWU1x5y=XHm5Q@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Greg Stark <stark@mit.edu>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Dec 21, 2012 at 10:54:21PM +0000, Greg Stark wrote:
> took about 30 minutes. I don't know why or what happened there. But it

Big snapshots take a long time to load - the whole cow area has to be
scanned to generate the list of blocks represented on it.

(Large thin snapshots don't have this shortcoming.)

Alasdair
