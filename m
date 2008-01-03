From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: NULL pointer issue in dm-mpath.c
Date: Thu, 03 Jan 2008 10:07:53 -0500
Message-ID: <477CFA49.3040001@hp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

While looking at this file, I noticed:

         if (!pgpath->pg->ps.type) {
                 DMWARN("Reinstate path not supported by path selector %s",
                        pgpath->pg->ps.type->name);
                 r = -EINVAL;
                 goto out;
         }

The DMWARN will end up following a NULL pointer (as pgpath->pg->ps.type 
is NULL). I have no idea how to fix this, nor if its really possible to 
hit this error case, nonetheless I thought I'd point this out. (As maybe 
someone out there would know how to correctly patch this.)

Regards,
Alan D. Brunelle
HP Open Source & Linux Organization / Scalability & Performance Group
