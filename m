From: "goggin, edward" <egoggin@emc.com>
Subject: curious why waitevent sets event_nr field of
	event_thread struct from kernel every time.
Date: Tue, 29 Mar 2005 17:15:24 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A883@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
Cc: 'Alasdair G Kergon' <agk@redhat.com>, 'Christophe Varoqui' <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

The multipathd from 0.4.4-pre4 has died a 3 more times.
I am still not sure what's up here.

Also, curious why waitevent() always sets the event_nr
field of the event_thread structure in multipathd to
the event number value pulled from the kernel for the
mapped device instead of using the event number
currently saved in the event_thread structure?

While I can see getting the number from the kernel the
first time through the code for each mapped device, I
think the way it is coded it is possible to lose events.

I think events can get lost if they occur between the
time multipath pulls out the kernel path state for the
affected mapped device for the previously detected event
and the time that the new waitevent pthread calls waitevent
for the same mapped device.  Granted, the pthread will
likely make it first -- but there is nothing in place which
makes this so.
