From: David Binderman <dcb314@hotmail.com>
Subject: drivers/md/dm-mpath.c:478: suspicious code ?
Date: Fri, 6 Jan 2017 17:52:21 +0000
Message-ID: <VI1PR08MB10227DFB2600B24201D3209D9C630@VI1PR08MB1022.eurprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "shli@kernel.org" <shli@kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

Hello there,

drivers/md/dm-mpath.c:478:19: warning: decrement of a boolean expression [-Wbool-operation]

Source code is

   } while (bypassed--);

Suggest code rework. Maybe a boolean / int type mixup ?

Regards

David Binderman
