From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: Re: multipathd will not set the iscsi session tmo after
 iscsi sesstion recovery
Date: Wed, 18 Apr 2018 10:33:26 +0800
Message-ID: <6bc38e7a-3e9c-3f07-f9f0-abbb16f3c8a3@oracle.com>
References: <de942eab-4456-fc6d-d588-79bb7a0513e1@oracle.com>
	<2a4eb120-d1f6-f7e0-4613-0403eb1ffbba@oracle.com>
	<20180417192638.GL3103@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180417192638.GL3103@octiron.msp.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, shinya.narahara@oracle.com
List-Id: dm-devel.ids

Hi Ben

Thanks for your kindly response.

On 04/18/2018 03:26 AM, Benjamin Marzinski wrote:
>>> When the iscsi session fails and do the recovery, iscsid will set parameters again.
>>> But this will overwrite the ones which has been set by multipathd.
>>> And multipathd will not set the iscsi session tmo parameters when path down and up.
> I would rather see if iscsid could skip reseting the parameters if they have
> been changed outside the program. If not, then multipathd could check
> and reset the parameters whenever a path comes back up.  But if iscsid
> is resetting it there, might it not be resetting it elsewhere?

As I know, iscsid would only set the parameters during setup the session.
multipathd + iscsid is common case, it is really worthy to provide a fix
for the parameter reseting when path up/down.

Thanks
Jianchao
