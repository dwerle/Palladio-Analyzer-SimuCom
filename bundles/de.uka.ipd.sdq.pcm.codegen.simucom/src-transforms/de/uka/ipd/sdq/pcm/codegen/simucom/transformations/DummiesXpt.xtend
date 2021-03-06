package de.uka.ipd.sdq.pcm.codegen.simucom.transformations

import com.google.inject.Inject
import de.uka.ipd.sdq.pcm.codegen.simucom.helper.M2TFileSystemAccess
import org.palladiosimulator.pcm.repository.InfrastructureInterface
import org.palladiosimulator.pcm.repository.InfrastructureRequiredRole
import org.palladiosimulator.pcm.repository.InfrastructureSignature
import org.palladiosimulator.pcm.repository.OperationInterface
import org.palladiosimulator.pcm.repository.OperationRequiredRole
import org.palladiosimulator.pcm.repository.OperationSignature
import org.palladiosimulator.pcm.system.System

abstract class DummiesXpt {
	@Inject M2TFileSystemAccess fsa
	
	@Inject extension JavaNamesExt
	@Inject extension JavaCoreXpt
	
	def dispatch void dummyComponent(OperationRequiredRole orr, System s) {
		val fileName = (s.implementationPackage()+"."+orr.fqnDummyComponent()).fqnToDirectoryPath()+".java"
		val fileContent = '''
			package «s.implementationPackage()».«orr.fqnDummyComponentPackage()»;
					
			public class «orr.dummyComponentName()»
			implements «orr.requiredInterface__OperationRequiredRole.fqn()» {
				private static org.apache.log4j.Logger logger = 
					org.apache.log4j.Logger.getLogger(«orr.dummyComponentName()».class.getName());
				«orr.requiredInterface__OperationRequiredRole.dummyComponentPortHelperMethodTM»
				«FOR signature : orr.requiredInterface__OperationRequiredRole.signatures__OperationInterface»
				«signature.dummyMethod(s, orr)»
				«ENDFOR»
			}
		'''
		
		fsa.generateFile(fileName, fileContent)
	}
	
	def dispatch void dummyComponent(InfrastructureRequiredRole irr, System s) {
		val fileName = (s.implementationPackage()+"."+irr.fqnDummyComponent()).fqnToDirectoryPath()+".java"
		val fileContent = '''
			package «s.implementationPackage()».«irr.fqnDummyComponentPackage()»;
			
			public class «irr.dummyComponentName()» 
			implements «irr.requiredInterface__InfrastructureRequiredRole.fqn()» {
				private static org.apache.log4j.Logger logger = 
					org.apache.log4j.Logger.getLogger(«irr.dummyComponentName()».class.getName());
				«irr.requiredInterface__InfrastructureRequiredRole.dummyComponentPortHelperMethodTM»
				«FOR signature : irr.requiredInterface__InfrastructureRequiredRole.infrastructureSignatures__InfrastructureInterface»
				«signature.dummyMethod(s, irr)»
				«ENDFOR»
			}
		'''
		
		fsa.generateFile(fileName, fileContent)
	}
	
	def dispatch dummyMethod(OperationSignature os, System s, OperationRequiredRole r) '''
		public «os.operationSignature» {
			«os.dummyMethodBodyTM(s, r)»
		}
	'''
	
	def dispatch dummyMethod(InfrastructureSignature is, System s, InfrastructureRequiredRole r) '''
		public «is.infrastructureSignature» {
			«is.dummyMethodBodyTM(s, r)»
		}
	'''
	
	//---------------------------------------------
	// Template method to generate code for the body
	// of dummy components attached to the unbound
	// system required roles
	//---------------------------------------------
	def CharSequence dummyMethodBodyTM(OperationSignature os, System s, OperationRequiredRole r)
	
	def CharSequence dummyMethodBodyTM(InfrastructureSignature os, System s, InfrastructureRequiredRole r)
	
	def CharSequence dummyComponentPortHelperMethodTM(OperationInterface oi)
	
	def CharSequence dummyComponentPortHelperMethodTM(InfrastructureInterface oi)
}