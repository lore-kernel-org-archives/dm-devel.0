From: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Subject: Re: [RFC][PATCH 0/3] persistent management feature for
	multipath-tools
Date: Tue, 20 Dec 2011 19:05:09 +0530
Message-ID: <EE2129A8E578DC4E94D643D6C1C1C67D07A576CC@BTCMVEXC2-PRD.hq.netapp.com>
References: <EE2129A8E578DC4E94D643D6C1C1C67D078966CE@BTCMVEXC2-PRD.hq.netapp.com>
	<1324332972.4565.46.camel@lapoo.opensvc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1324332972.4565.46.camel@lapoo.opensvc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, device-mapper development <dm-devel@redhat.com>
Cc: "Moger, Babu" <Babu.Moger@netapp.com>, "Stankey,
	Robert" <Robert.Stankey@netapp.com>, "Dachepalli,
	Sudhir" <Sudhir.Dachepalli@netapp.com>
List-Id: dm-devel.ids

On Tue, Dec 20, 2011 at 3:46 AM, Christophe Varoqui <christophe.varoqui@gmail.com> wrote:
>On lun., 2011-12-19 at 22:04 +0530, Chauhan, Vijay wrote:
>>
>Persistent reservation is a path-centric command set. I don't see
>clearly the benefit of folding (obfuscating?) it into the multipath
>layer.

Christophe, Thanks for your comments.
Yes, I agree. The persistent reservation model specified by T10 SPC defines that volume reservation should be identified by I_T nexuses. And also multipath layer well knows about the mapping between physical path and mpath device. 

In addition, dynamic addition/deletion and path state change of physical paths are other complexities that could be handled in multipath layer effectively.   

>
>Saving a few command lines ? I don't think there are wild admins playing
>with PR without a clustering toolkit out there, so the tricky command
>lines don't really matter.

I did not mean that this feature replaces clustering toolkit rather this feature supports clustering toolkit (which usages mpath device) by hiding complexities in multipath layer as mentioned above. Can you please be more specific if you are referring to any drawback using this feature?

>
>I do maintain a clustering toolkit that handles PR, and I know this
>feature would add code (multipath specific), not remove the current more
>generic code.
>
While implementing this feature,  we have tried be generic which could work with other cluster solutions as well. If you still feel there is any scope of improvement then I can work on it. Your feedback with use-cases would be helpful.   

>I also realize some other multipath implementations (PowerPath for one)
>propose that feature. I'm curious to know the motivation.
>
We are successfully using feature with one of the cluster solution and thought of posting it to this forum if it could benefit others as well as being a generic implementation.

>Am I the only one on the list thinking along this line ? Anyway, I have
>no hard feelings against this work.
>
>Best regards,
>Christophe Varoqui
>
>>
>> This feature enables mpath device to be used with cluster application.
