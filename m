From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipathd: check and cleanup zombie paths
Date: Fri, 9 Mar 2018 11:47:27 +0100
Message-ID: <4d76e9a1-15bf-2bf4-c7dc-adf79b25e4a2@gmail.com>
References: <CEB9978CF3252343BE3C67AC9F0086A34295C462@H3CMLB14-EX.srv.huawei-3com.com>
	<1520325779.4131.4.camel@suse.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295C9D0@H3CMLB14-EX.srv.huawei-3com.com>
	<1520349519.4131.20.camel@suse.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295CA7D@H3CMLB14-EX.srv.huawei-3com.com>
	<1520426679.11340.5.camel@suse.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295CF62@H3CMLB14-EX.srv.huawei-3com.com>
	<20180308154435.GB14513@octiron.msp.redhat.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295D215@H3CMLB14-EX.srv.huawei-3com.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CEB9978CF3252343BE3C67AC9F0086A34295D215@H3CMLB14-EX.srv.huawei-3com.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Chongyun Wu <wu.chongyun@h3c.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Guozhonghua <guozhonghua@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Changwei Ge <ge.changwei@h3c.com>, Changlimin <changlimin@h3c.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

On 03/09/2018 07:47 AM, Chongyun Wu wrote:

> You just mentioned *the TUR checker could return a special path state 
> for this*, what is the special path state?  Thanks~

to follow with this bug, you should post:
- distribution
- kernel release
- multipath-tools release
- /etc/multipath.conf
- and relevant system logs (multipath -v3 -d, journalctl, dmesg, messages, ...)
