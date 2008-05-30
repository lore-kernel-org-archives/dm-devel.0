From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Read-only devices, multipath-tools : update
Date: Fri, 30 May 2008 21:00:29 +0200
Message-ID: <1212174029.7996.15.camel@plop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Ben,

this note to point to you that the upstream tools repo has a change-set
commited that implements the fallback to read-only devmap loading. It
could help with your open bugzillas.

Now, as Alasdair agreed to permit loading RW devmap for multipath maps
over RO devices (*), I don't know if it's really needed ... but it can't
hurt.

(*) https://www.redhat.com/archives/dm-devel/2008-May/msg00128.html

Regards,
cvaroqui
